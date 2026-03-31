-- # Trabalho de Fundamentos de Bancos de Dados (INF01145) - etapa III
-- # Arthur Prochnow Baumgardt & Leonardo da Silva Junqueira
-- # SGBD: postgresql

-- Descricao do gatilho:
-- O objetivo é otimizar a contagem de curtidas para os posts,
-- em vez de executar um count(*) custoso na tabela "likes" toda vez
-- o gatilho atualiza um contador, a coluna "likes_count", diretamente na tabela "posts".
-- A função `update_likes_count_func` é acionada pelo gatilho
-- toda vez que uma linha é inserida ou removida da tabela "likes",
-- incrementando ou decrementando o valor da coluna


-- altera a tabela "posts" para adicionar a coluna de contagem.
alter table posts add column likes_count integer not null default 0;


-- cria a stored procedure para o gatilho
create or replace function update_likes_count_func()
returns trigger as $$
begin
    if (tg_op = 'INSERT') then
        update posts
        set likes_count = likes_count + 1
        where id_post = new.id_post;
    elsif (tg_op = 'DELETE') then
        update posts
        set likes_count = likes_count - 1
        where id_post = old.id_post;
    end if;
    -- ignora gatilhos after
    return null;
end;
$$ language plpgsql;


-- cria o gatilho que associa a função à tabela "likes".
drop trigger if exists likes_count_trigger on likes;
create trigger likes_count_trigger
    after insert or delete on likes
    for each row
    execute function update_likes_count_func();
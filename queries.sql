-- Visão que consolida informações sobre cada post,
-- incluindo os nicknames dos autores, a data de criação do post (primeira autoria),
-- a legenda, a localização, a quantidade de curtidas, de comentários,
-- e a quantidade de mídias associadas.
create view vw_post_details as
select
    p.id_post,
    p.caption,
    p.local,
    min(a.datetime) as post_creation_datetime, 
    string_agg(u.nickname, ', ') as authors_nickname,
    coalesce(likes_counts.total_likes, 0) as total_likes,
    coalesce(comments_counts.total_comments, 0) as total_comments,
    coalesce(media_counts.total_media, 0) as total_media
from
    posts p
join
    authorship a on p.id_post = a.id_post
join
    users u on a.id_user = u.id_user
left join (
    select id_post, count(id_interac) as total_likes
    from likes
    group by id_post
) as likes_counts on p.id_post = likes_counts.id_post
left join (
    select id_post, count(id_interac) as total_comments
    from comments
    group by id_post
) as comments_counts on p.id_post = comments_counts.id_post
left join (
    select id_post, count(id_midia) as total_media
    from midias
    group by id_post
) as media_counts on p.id_post = media_counts.id_post
group by    p.id_post,
    p.caption,
    p.local,
    coalesce(likes_counts.total_likes, 0),
    coalesce(comments_counts.total_comments, 0),
    coalesce(media_counts.total_media, 0)
order by
    post_creation_datetime desc;


-- Consulta 1: Obter o número total de posts, curtidas e comentários que cada usuário fez, listando apenas aqueles com pelo menos uma postagem ou interação.
select
    u.nickname,
    count(distinct a.id_post) as total_posts_authored,
    count(distinct li.id_interac) as total_likes_given,
    count(distinct c.id_interac) as total_comments_given
from
    users u
left join
    authorship a on u.id_user = a.id_user
left join
    interactions i on u.id_user = i.id_user
left join
    likes li on i.id_interac = li.id_interac
left join
    comments c on i.id_interac = c.id_interac
group by
    u.id_user, u.nickname
having
    count(distinct a.id_post) >= 1 or count(distinct i.id_interac) >= 1
order by
    total_posts_authored desc, total_likes_given desc, total_comments_given desc;


-- Consulta 2: Listar todas as postagens (id, legenda, localização) que contêm tanto fotos quanto vídeos.
select
    p.id_post,
    p.caption,
    p.local
from
    posts p
where
    exists (select 1 from midias m join photos ph on m.id_midia = ph.id_midia where m.id_post = p.id_post)
and
    exists (select 1 from midias m join videos v on m.id_midia = v.id_midia where m.id_post = p.id_post);


-- Consulta 3: Encontrar os usuários que seguem o usuário com o nickname 'arthur' e que também foram seguidos por ele (seguidores mútuos),
-- mostrando também quantos posts eles marcaram o 'arthur' ou foram marcados pelo 'arthur'.
select
    u1.nickname as follower_nickname,
    count(distinct upt.id_post) as mutual_tags_count
from
    users u1
join
    connect c1 on u1.id_user = c1.id_follower
join
    users u2 on c1.id_following = u2.id_user
left join
    user_post_tag upt on (upt.id_user = u1.id_user and upt.id_post in (
                                select p.id_post from posts p
                                join authorship a on p.id_post = a.id_post
                                where a.id_user = u2.id_user)
                            or (upt.id_user = u2.id_user and upt.id_post in (
                                select p.id_post from posts p
                                join authorship a on p.id_post = a.id_post
                                where a.id_user = u1.id_user))
                            )
where
    u2.nickname = 'arthur'
    and exists (
        select 1
        from connect c2
        where c2.id_follower = u2.id_user and c2.id_following = u1.id_user
    )
group by u1.nickname;


-- Consulta 4: Listar todas as mensagens enviadas por um usuário específico ('arthur') para outro ('leonardo') que ainda não foram visualizadas.
select
    i.datetime as message_datetime,
    m.msg_text
from
    messages m
join
    interactions i on m.id_interac = i.id_interac
join
    users sender on i.id_user = sender.id_user
join
    users receiver on m.id_user_dest = receiver.id_user
where
    sender.nickname = 'arthur' and receiver.nickname = 'leonardo'
    and m.msg_viewed = false;


-- Consulta 5: Obter o número de postagens por localização, apenas para locais que têm mais de 2 postagens,
-- e o número de autores distintos que publicaram nesses locais.
select
    p.local,
    count(distinct p.id_post) as num_posts,
    count(distinct u.nickname) as num_distinct_authors
from
    posts p
join
    authorship a on p.id_post = a.id_post
join
    users u on a.id_user = u.id_user
where
    p.local is not null
group by
    p.local
having
    count(distinct p.id_post) > 2
order by
    num_posts desc;


-- Consulta 6: Encontrar todas as postagens (id e legenda) que não contêm nenhuma hashtag,
-- mostrando também o nickname do autor principal.
select
    p.id_post,
    p.caption,
    string_agg(u.nickname, ', ') as authors_nickname
from
    posts p
left join
    authorship a on p.id_post = a.id_post
left join
    users u on a.id_user = u.id_user
where
    not exists (
        select 1
        from post_hashtag ph
        where ph.id_post = p.id_post
    )
group by
    p.id_post, p.caption;


-- Consulta 7: Encontrar usuários que curtiram todas as publicações feitas pelo usuário com nickname 'arthur'.
select
    u.nickname
from
    users u
where not exists (
    select p.id_post
    from posts p
    join authorship a on p.id_post = a.id_post
    join users author on a.id_user = author.id_user
    where author.nickname = 'arthur'
    and not exists (
        select 1
        from likes l
        join interactions i on l.id_interac = i.id_interac
        where i.id_user = u.id_user and l.id_post = p.id_post
    )
);


-- Consulta 8: Listar as postagens (id, legenda, autores, total de curtidas e comentários) que têm mais de 5 curtidas,
-- mostrando também o e-mail do autor principal, utilizando a visão 'vw_post_details'.
select
    vpd.id_post,
    vpd.caption,
    vpd.authors_nickname,
    vpd.total_likes,
    vpd.total_comments,
    u.email as main_author_email
from
    vw_post_details vpd
join
    authorship a on vpd.id_post = a.id_post
join
    users u on a.id_user = u.id_user
where
    vpd.total_likes > 5
group by
    vpd.id_post, vpd.caption, vpd.authors_nickname, vpd.total_likes, vpd.total_comments, u.email
order by
    vpd.total_likes desc;


-- Consulta 9: Encontrar o post com o maior número de curtidas, utilizando a visão 'vw_post_details',
-- mostrando também a data de nascimento do autor principal.
select
    vpd.caption,
    vpd.authors_nickname,
    vpd.total_likes,
    u.dt_birth as main_author_birth_date
from
    vw_post_details vpd
join
    authorship a on vpd.id_post = a.id_post
join
    users u on a.id_user = u.id_user
order by
    vpd.total_likes desc
limit 1;


-- Consulta 10: Encontra todos os comentários feitos em posts que contenham a hashtag '#tbt',
-- mostrando o nickname do autor do comentário e o texto do comentário.
select
    u.nickname as commenter_nickname,
    c.com_text
from
    comments c
join
    interactions i on c.id_interac = i.id_interac
join
    users u on i.id_user = u.id_user
join
    posts p on c.id_post = p.id_post
join
    post_hashtag ph on p.id_post = ph.id_post
join
    hashtags h on ph.id_hash = h.id_hash
where
    h.hash_text = '#tbt';
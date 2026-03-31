-- ENTIDADES

-- Tabela para a entidade User (Usuário)
-- Baseado no Dicionário de Dados 
create table users (
    id_user serial primary key,
    nickname text not null unique,
    email text not null unique,
    dt_birth timestamp not null,
    dt_creation timestamp not null default current_timestamp
);

-- Tabela para a entidade Post (Publicação)
-- Baseado no Dicionário de Dados 
create table posts (
    id_post serial primary key,
    caption text,
    local text
);

-- Tabela para a entidade genérica "Midia"
-- Baseado no Dicionário de Dados.
-- O relacionamento "Contain"  é implementado com a FK "id_post".
create table midias (
    id_midia serial primary key,
    id_post integer not null,
    url text not null,
    foreign key (id_post) references posts(id_post) on delete cascade
);

-- Tabela para a especialização "Photo" (Foto)
-- Contém atributos específicos de Foto.
create table photos (
    id_midia integer primary key,
    resolution text,
    filter text,
    foreign key (id_midia) references midias(id_midia) on delete cascade
);

-- Tabela para a especialização "Video"
-- Contém atributos específicos de Vídeo.
create table videos (
    id_midia integer primary key,
    duration time,
    thumbnail text,
    foreign key (id_midia) references midias(id_midia) on delete cascade
);

-- Tabela para a entidade "Hashtag"
-- Baseado no Dicionário de Dados.
create table hashtags (
    id_hash serial primary key,
    hash_text text not null unique
);

-- Tabela para a entidade genérica "Interaction" (Interação)
-- Baseado no Dicionário de Dados.
-- O relacionamento "Interact"  é implementado com a FK "id_user".
create table interactions (
    id_interac serial primary key,
    id_user integer not null,
    datetime timestamp not null default current_timestamp,
    foreign key (id_user) references users(id_user) on delete cascade
);

-- Tabela para a especialização "Like" (Curtida)
-- Representa uma curtida em um post.
-- O relacionamento "Add"  é implementado com a FK "id_post".
create table likes (
    id_interac integer primary key,
    id_post integer not null,
    foreign key (id_interac) references interactions(id_interac) on delete cascade,
    foreign key (id_post) references posts(id_post) on delete cascade
);

-- Tabela para a especialização "Comment" (Comentário)
-- Representa um comentário em um post.
-- O relacionamento "Write"  é implementado com a FK "id_post".
create table comments (
    id_interac integer primary key,
    id_post integer not null,
    com_text text not null,
    foreign key (id_interac) references interactions(id_interac) on delete cascade,
    foreign key (id_post) references posts(id_post) on delete cascade
);

-- Tabela para a especialização "Message" (Mensagem)
-- Representa uma mensagem direta entre usuários.
-- O relacionamento "Chat"  é mapeado com a FK "id_user_dest".
-- O remetente é o "id_user" da tabela "Interaction" pai.
create table messages (
    id_interac integer primary key,
    id_user_dest integer not null,
    msg_text text not null,
    msg_viewed boolean not null default false,
    foreign key (id_interac) references interactions(id_interac) on delete cascade,
    foreign key (id_user_dest) references users(id_user) on delete cascade
);


-- RELACIONAMENTOS

-- Tabela para o relacionamento N:M "Connect" (Seguidores)
-- Representa um usuário seguindo outro.
create table connect (
    id_follower integer not null,
    id_following integer not null,
    primary key (id_follower, id_following),
    foreign key (id_follower) references users(id_user) on delete cascade,
    foreign key (id_following) references users(id_user) on delete cascade
);

-- Tabela para o relacionamento N:M "Authorship" (Autoria)
-- Associa um ou mais usuários a uma publicação.
-- Contém um atributo "datetime" do próprio relacionamento.
create table authorship (
    id_user integer not null,
    id_post integer not null,
    datetime timestamp not null default current_timestamp,
    primary key (id_user, id_post),
    foreign key (id_user) references users(id_user) on delete cascade,
    foreign key (id_post) references posts(id_post) on delete cascade
);

-- Tabela para o relacionamento N:M "Use"
-- Associa uma ou mais hashtags a uma publicação.
create table post_hashtag (
    id_post integer not null,
    id_hash integer not null,
    primary key (id_post, id_hash),
    foreign key (id_post) references posts(id_post) on delete cascade,
    foreign key (id_hash) references hashtags(id_hash) on delete cascade
);

-- Tabela para o relacionamento N:M "Tag" (Marcação de usuário em post)
-- Baseado no DER, modela um usuário sendo marcado em um post.
create table user_post_tag (
    id_user integer not null,
    id_post integer not null,
    primary key (id_user, id_post),
    foreign key (id_user) references users(id_user) on delete cascade,
    foreign key (id_post) references posts(id_post) on delete cascade
);


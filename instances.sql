-- inserindo usuários
insert into users (nickname, email, dt_birth) values
('arthur', 'arthur@email.com', '2000-04-10'),
('leonardo', 'leo@email.com', '2001-07-22'),
('grazi', 'grazi@email.com', '1985-03-15'),
('pedro', 'pedro@email.com', '1999-11-01'),
('ana', 'ana@email.com', '2002-02-25'),
('maria', 'maria@email.com', '1993-01-20'),
('carlos', 'carlos@email.com', '1988-06-05');

-- inserindo conexões
insert into connect (id_follower, id_following) values
(2, 1), (3, 1), (4, 1), (5, 1),
(1, 2), (1, 3),
(6, 1), (7, 1);

-- inserindo posts
insert into posts (caption, local) values
('Um belo dia na praia!', 'Praia de Torres, RS'),
('Meu novo projeto de BD.', 'Porto Alegre, RS'),
('Saudades dessa viagem! #tbt', 'Gramado, RS'),
('Post colaborativo!', 'UFRGS'),
('Apenas um post de teste.', null),
('Fim de tarde na capital.', 'Porto Alegre, RS'),
('Apresentação importante.', 'Porto Alegre, RS'),
('Nova tecnologia de ponta', null),
('Exemplo de post com foto e vídeo.', 'Porto Alegre, RS');

-- inserindo autoria
insert into authorship (id_user, id_post, datetime) values
(1, 1, '2025-01-10 10:00:00'),
(1, 2, '2025-02-01 11:00:00'),
(2, 3, '2025-03-01 12:00:00'),
(1, 4, '2025-04-01 13:00:00'),
(2, 4, '2025-04-01 13:00:00'),
(3, 5, '2025-05-01 14:00:00'),
(4, 6, '2025-05-10 15:00:00'),
(5, 7, '2025-05-11 16:00:00'),
(1, 8, '2025-06-01 17:00:00'),
(1, 9, '2025-06-15 10:00:00');

-- inserindo mídias e suas especializações
insert into midias (id_post, url) values (1, 'http://example.com/foto1.jpg');
insert into photos (id_midia, resolution, filter) values (1, '1080x1080', 'Clarendon');

insert into midias (id_post, url) values (2, 'http://example.com/video1.mp4');
insert into videos (id_midia, duration, thumbnail) values (2, '00:00:15', 'http://example.com/thumb1.jpg');

insert into midias (id_post, url) values (3, 'http://example.com/foto2.jpg');
insert into photos (id_midia, resolution) values (3, '1920x1080');
insert into midias (id_post, url) values (3, 'http://example.com/foto3.jpg');
insert into photos (id_midia, resolution) values (4, '1920x1080');

insert into midias (id_post, url) values (4, 'http://example.com/foto4.jpg');
insert into photos (id_midia, resolution) values (5, '1000x1000');

insert into midias (id_post, url) values (8, 'http://example.com/foto8.jpg');
insert into photos (id_midia, resolution) values (6, '800x600');
insert into midias (id_post, url) values (8, 'http://example.com/video8.mp4');
insert into videos (id_midia, duration, thumbnail) values (7, '00:00:20', 'http://example.com/thumb8.jpg');

insert into midias (id_post, url) values (9, 'http://example.com/foto9.jpg');
insert into photos (id_midia, resolution) values (8, '1200x800');
insert into midias (id_post, url) values (9, 'http://example.com/video9.mp4');
insert into videos (id_midia, duration, thumbnail) values (9, '00:00:30', 'http://example.com/thumb9.jpg');


-- inserindo hashtags
insert into hashtags (hash_text) values ('#praia'), ('#ufrgs'), ('#tbt'), ('#database'), ('#capital');

-- associando hashtags aos posts
insert into post_hashtag (id_post, id_hash) values
(1, 1),
(2, 2), (2, 4),
(3, 3),
(6, 5),
(9, 2);

-- Inserindo Likes
with new_like_interaction as (
    insert into interactions (id_user, datetime) values (2, '2025-01-10 10:10:00') returning id_interac
)
insert into likes (id_interac, id_post) select id_interac, 1 from new_like_interaction;

with new_like_interaction as (
    insert into interactions (id_user, datetime) values (3, '2025-01-10 10:15:00') returning id_interac
)
insert into likes (id_interac, id_post) select id_interac, 1 from new_like_interaction;

with new_like_interaction as (
    insert into interactions (id_user, datetime) values (4, '2025-01-10 10:20:00') returning id_interac
)
insert into likes (id_interac, id_post) select id_interac, 1 from new_like_interaction;

with new_like_interaction as (
    insert into interactions (id_user, datetime) values (5, '2025-01-10 10:25:00') returning id_interac
)
insert into likes (id_interac, id_post) select id_interac, 1 from new_like_interaction;

with new_like_interaction as (
    insert into interactions (id_user, datetime) values (6, '2025-01-10 10:30:00') returning id_interac
)
insert into likes (id_interac, id_post) select id_interac, 1 from new_like_interaction;

with new_like_interaction as (
    insert into interactions (id_user, datetime) values (7, '2025-01-10 10:35:00') returning id_interac
)
insert into likes (id_interac, id_post) select id_interac, 1 from new_like_interaction;

with new_like_interaction as (
    insert into interactions (id_user, datetime) values (1, '2025-01-10 10:40:00') returning id_interac
)
insert into likes (id_interac, id_post) select id_interac, 1 from new_like_interaction;

with new_like_interaction as (
    insert into interactions (id_user, datetime) values (2, '2025-02-01 11:10:00') returning id_interac
)
insert into likes (id_interac, id_post) select id_interac, 2 from new_like_interaction;

with new_like_interaction as (
    insert into interactions (id_user, datetime) values (4, '2025-02-01 11:15:00') returning id_interac
)
insert into likes (id_interac, id_post) select id_interac, 2 from new_like_interaction;

with new_like_interaction as (
    insert into interactions (id_user, datetime) values (1, '2025-03-01 12:30:00') returning id_interac
)
insert into likes (id_interac, id_post) select id_interac, 3 from new_like_interaction;

with new_like_interaction as (
    insert into interactions (id_user, datetime) values (6, '2025-06-02 08:00:00') returning id_interac
)
insert into likes (id_interac, id_post) select id_interac, 1 from new_like_interaction;

with new_like_interaction as (
    insert into interactions (id_user, datetime) values (6, '2025-06-02 08:05:00') returning id_interac
)
insert into likes (id_interac, id_post) select id_interac, 2 from new_like_interaction;

with new_like_interaction as (
    insert into interactions (id_user, datetime) values (6, '2025-06-02 08:10:00') returning id_interac
)
insert into likes (id_interac, id_post) select id_interac, 4 from new_like_interaction;

with new_like_interaction as (
    insert into interactions (id_user, datetime) values (6, '2025-06-02 08:15:00') returning id_interac
)
insert into likes (id_interac, id_post) select id_interac, 8 from new_like_interaction;

with new_like_interaction as (
    insert into interactions (id_user, datetime) values (2, '2025-01-10 10:45:00') returning id_interac
)
insert into likes (id_interac, id_post) select id_interac, 1 from new_like_interaction;

with new_like_interaction as (
    insert into interactions (id_user, datetime) values (3, '2025-01-10 10:50:00') returning id_interac
)
insert into likes (id_interac, id_post) select id_interac, 1 from new_like_interaction;

with new_like_interaction as (
    insert into interactions (id_user, datetime) values (4, '2025-01-10 10:55:00') returning id_interac
)
insert into likes (id_interac, id_post) select id_interac, 1 from new_like_interaction;

with new_like_interaction as (
    insert into interactions (id_user, datetime) values (5, '2025-01-10 11:00:00') returning id_interac
)
insert into likes (id_interac, id_post) select id_interac, 1 from new_like_interaction;

with new_like_interaction as (
    insert into interactions (id_user, datetime) values (6, '2025-01-10 11:05:00') returning id_interac
)
insert into likes (id_interac, id_post) select id_interac, 1 from new_like_interaction;

with new_like_interaction as (
    insert into interactions (id_user, datetime) values (7, '2025-01-10 11:10:00') returning id_interac
)
insert into likes (id_interac, id_post) select id_interac, 1 from new_like_interaction;

with new_like_interaction as (
    insert into interactions (id_user, datetime) values (6, '2025-06-15 10:15:00') returning id_interac
)
insert into likes (id_interac, id_post) select id_interac, 9 from new_like_interaction;


-- Inserindo Comments
with new_comment_interaction as (
    insert into interactions (id_user, datetime) values (2, '2025-01-10 10:12:00') returning id_interac
)
insert into comments (id_interac, id_post, com_text) select id_interac, 1, 'Que foto incrível!' from new_comment_interaction;

with new_comment_interaction as (
    insert into interactions (id_user, datetime) values (3, '2025-03-01 12:15:00') returning id_interac
)
insert into comments (id_interac, id_post, com_text) select id_interac, 3, 'Lugar lindo!' from new_comment_interaction;

with new_comment_interaction as (
    insert into interactions (id_user, datetime) values (1, '2025-03-01 12:20:00') returning id_interac
)
insert into comments (id_interac, id_post, com_text) select id_interac, 3, 'Concordo, muito bom! #tbt' from new_comment_interaction;


-- Inserindo Messages
with new_message_interaction as (
    insert into interactions (id_user, datetime) values (1, '2025-04-05 09:00:00') returning id_interac
)
insert into messages (id_interac, id_user_dest, msg_text) select id_interac, 2, 'E aí, tudo certo para a apresentação?' from new_message_interaction;

with new_message_interaction as (
    insert into interactions (id_user, datetime) values (2, '2025-04-05 09:05:00') returning id_interac
)
insert into messages (id_interac, id_user_dest, msg_text) select id_interac, 1, 'Tudo certo! Já finalizei minha parte.' from new_message_interaction;

with new_message_interaction as (
    insert into interactions (id_user, datetime) values (1, '2025-04-05 09:10:00') returning id_interac
)
insert into messages (id_interac, id_user_dest, msg_text) select id_interac, 2, 'Perfeito!' from new_message_interaction;

-- inserindo marcações de usuários em posts
insert into user_post_tag (id_user, id_post) values
(2, 1),
(1, 4),
(3, 4);
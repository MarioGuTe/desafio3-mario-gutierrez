CREATE DATABASE "desafio3-Mario-Gutierrez-333";


/* Crear y poblar tabla usuarios */
CREATE TABLE IF NOT EXISTS USUARIOS 
(id SERIAL, email VARCHAR, nombre VARCHAR, apellido VARCHAR, rol VARCHAR);

INSERT INTO USUARIOS (email, nombre, apellido, rol)
VALUES ('email1@gmail.com', 'nombre1', 'apellido1', 'administrador');

INSERT INTO USUARIOS (email, nombre, apellido, rol)
VALUES ('email2@gmail.com', 'nombre2', 'apellido2', 'usuario');

INSERT INTO USUARIOS (email, nombre, apellido, rol)
VALUES ('email3@gmail.com', 'nombre3', 'apellido3', 'usuario');

INSERT INTO USUARIOS (email, nombre, apellido, rol)
VALUES ('email4@gmail.com', 'nombre4', 'apellido4', 'usuario');

INSERT INTO USUARIOS (email, nombre, apellido, rol)
VALUES ('email5@gmail.com', 'nombre5', 'apellido5', 'usuario');

/* Crear y poblar tabla Posts */
CREATE TABLE IF NOT EXISTS POSTS 
(id SERIAL, titulo VARCHAR, contenido TEXT, fecha_creacion TIMESTAMP, 
 fecha_actualizacion TIMESTAMP, destacado BOOLEAN, usuario_id BIGINT);
 
INSERT INTO POSTS (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id)
VALUES ('post1', 'contenido1', '2020-01-01', '2020-01-02', TRUE, 1);

INSERT INTO POSTS (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id)
VALUES ('post2', 'contenido2', '2021-01-01', '2021-01-02', FALSE, 1);

INSERT INTO POSTS (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id)
VALUES ('post3', 'contenido3', '2022-01-01', '2022-01-02', FALSE, 2);

INSERT INTO POSTS (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id)
VALUES ('post4', 'contenido4', '2022-02-01', '2022-02-02', TRUE, 2);

INSERT INTO POSTS (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado)
VALUES ('post5', 'contenido5', '2021-03-01', '2021-04-02', FALSE);

/* Crear y Poblar Tabla Comentarios */
CREATE TABLE IF NOT EXISTS COMENTARIOS 
(id SERIAL, contenido TEXT, fecha_creacion TIMESTAMP, 
 usuario_id BIGINT, post_id BIGINT);
 
INSERT INTO COMENTARIOS (contenido, fecha_creacion, usuario_id, post_id)
VALUES ('comentario1', '2022-05-01', 1, 1);

INSERT INTO COMENTARIOS (contenido, fecha_creacion, usuario_id, post_id)
VALUES ('comentario2', '2022-05-02', 2, 1);

INSERT INTO COMENTARIOS (contenido, fecha_creacion, usuario_id, post_id)
VALUES ('comentario3', '2022-05-03', 3, 1);

INSERT INTO COMENTARIOS (contenido, fecha_creacion, usuario_id, post_id)
VALUES ('comentario4', '2022-05-04', 1, 2);

INSERT INTO COMENTARIOS (contenido, fecha_creacion, usuario_id, post_id)
VALUES ('comentario5', '2022-05-05', 2, 2);

/* Sección preguntas */

/* Pregunta 2: */
SELECT a.nombre, a.email, b.titulo, b.contenido 
FROM USUARIOS a
JOIN POSTS b
	ON (a.id = b.usuario_id);

/* Pregunta 3: */

SELECT b.id, b.titulo, b.contenido 
FROM USUARIOS a
JOIN POSTS b
	ON (a.id = b.usuario_id)
	AND (a.rol = 'administrador');
	
/* Pregunta 4: */
SELECT a.id, a.email, count(titulo) 
FROM USUARIOS a
LEFT JOIN POSTS b
	ON (a.id = b.usuario_id)
GROUP BY a.id, a.email
ORDER BY id;

/* Pregunta 5: */

SELECT a.email 
FROM USUARIOS a
LEFT JOIN POSTS b
	ON (a.id = b.usuario_id)
GROUP BY a.id, a.email
HAVING count(titulo) = (
	SELECT MAX(post_count)
	FROM(
	SELECT a.id, a.email, count(titulo) as post_count 
	FROM USUARIOS a
	LEFT JOIN POSTS b
		ON (a.id = b.usuario_id)
	GROUP BY a.id, a.email
) as sq)
LIMIT 1;

/* Pregunta 6: */

SELECT a.id, a.email, MAX(b.fecha_creacion) as ultimo_post
FROM USUARIOS a
LEFT JOIN POSTS b
	ON (a.id = b.usuario_id)
GROUP BY a.id, a.email;

/* Pregunta 7: */
SELECT titulo, contenido
FROM posts
WHERE id = (
	SELECT a.post_id
	FROM comentarios a
	JOIN posts b
		ON (a.post_id = b.id)
	GROUP BY a.post_id
	ORDER BY count(a.post_id) DESC
	LIMIT 1
);

/* Pregunta 8 */
SELECT a.titulo, a.contenido AS contenido_post, b.contenido as contenido_comentario, c.email
FROM posts a
LEFT JOIN comentarios b
	ON (a.id = b.post_id)
LEFT JOIN usuarios c
	ON (a.usuario_id = c.id);

/* Pregunta 9 */
SELECT d.id as id_usuario, sq.contenido
FROM usuarios d
LEFT JOIN (
	SELECT a.usuario_id, a.contenido
	FROM comentarios a
	JOIN (
	SELECT usuario_id, MAX(fecha_creacion) AS fecha_ultimo_comentario
	FROM comentarios
	GROUP BY usuario_id) sq
	ON (a.usuario_id = sq.usuario_id)
	AND (sq.fecha_ultimo_comentario = a.fecha_creacion)) sq
ON (d.id = sq.usuario_id);


/* Pregunta 10 */
SELECT a.email
FROM usuarios a
LEFT JOIN comentarios b
	ON (a.id = b.usuario_id)
WHERE b.id is null;




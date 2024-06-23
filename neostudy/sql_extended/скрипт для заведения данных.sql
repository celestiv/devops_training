create table authors (
	id int primary key,
	first_name varchar (50),
	last_name varchar (50)
);

insert into authors (id, first_name, last_name)
values
(1, 'Jack', 'Brown'),
(2, 'John', 'Doe'),
(3, 'Max', 'White');

create table tags (
	id int primary key,
	name varchar (50)
);

insert into tags (id, name)
values
(1,	'IT'),
(2,	'PHP'),
(3,	'JavaScript'),
(4,	'React'),
(5,	'Angular'),
(6,	'Vue.js'),
(7,	'C/C++'''),
(8,	'Rust');

create table posts (
	id int primary key,
	title varchar (50),
	likes int,
	author_id int,
	foreign key (author_id) references authors(id)
);

insert into posts (id, title, likes, author_id)
values
(1,	'Lorem ipsum',	3810,	2),
(2,	'Lorem ipsum dolor sit amet',	1913,	2),
(3,	'Lorem ipsum dolor sit',	4111,	1),
(4,	'Lorem ipsum dolor',	6700,	3);

create table post_tag (
	id int,
	post_id int,
	tag_id int,
	foreign key (post_id) references posts(id),
	foreign key (tag_id) references tags(id)
);

insert into post_tag (id, post_id, tag_id)
values
(1,	1,	1),
(2,	1,	2),
(3,	1,	3),
(4,	1,	4),
(5,	1,	5),
(6,	2,	7),
(7,	2,	6),
(8,	2,	5),
(9,	2,	1),
(10,	2,	3),
(11,	3,	1),
(12,	3,	7),
(13,	3,	5),
(14,	3,	6),
(15,	4,	5),
(16,	4,	1),
(17,	4,	7),
(18,	4,	6);
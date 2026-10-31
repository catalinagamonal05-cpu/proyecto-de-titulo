Create database nestly;
Use nestly;
CREATE TABLE usuario(
	id_usuario varchar(36) not null,
    nombre varchar (50) not null,
    email varchar (50) not null UNIQUE,
    contrasena varchar (255) not null,
    PRIMARY KEY (id_usuario)
);
INSERT INTO usuario (id_usuario, nombre, email, contrasena)
VALUES (UUID(), 'Usuario de prueba', 'c.gamonallen@uandresbello.edu', 'NARA');

CREATE TABLE gastos(
	id_gasto int not null auto_increment,
	id_usuario varchar(36) not null,
    pago varchar (50) default 'pendiente',
    UTM decimal(10, 4) not null,
    peso_chileno decimal(10, 2) not null,
    titulo_pago varchar (50) not null,
    porcentaje_pago int not null,
    fecha_pago date not null,
    fecha_pagado date,
    PRIMARY KEY (id_gasto),
    foreign key (id_usuario) references usuario(id_usuario)
);

CREATE TABLE eventos(
	id_evento int not null auto_increment,
    id_usuario varchar(36) not null,
    titulo_evento varchar (50) not null,
    cumplimiento varchar (50) default 'pendiente',
    duracion int not null,
    repeticion int not null,
    evento_inicio datetime not null,
    evento_termino datetime not null,
    PRIMARY KEY (id_evento),
    foreign key (id_usuario) references usuario(id_usuario)
);

create table chat(
	id_msj int not null auto_increment,
    id_usuario varchar(36) not null,
    contenido varchar (5000) not null,
    envio datetime default current_timestamp,
    filtro_aprobado boolean default true,
    PRIMARY KEY (id_msj),
    foreign key (id_usuario) references usuario(id_usuario)
);

create table docs(
	id_doc int not null auto_increment,
    id_usuario varchar(36) not null,
	url_arch varchar (500) not null,
    fecha_subida datetime default current_timestamp,
    PRIMARY KEY (id_doc),
    foreign key (id_usuario) references usuario(id_usuario)
);

ALTER TABLE usuario MODIFY COLUMN contrasena varchar(255) NOT NULL;
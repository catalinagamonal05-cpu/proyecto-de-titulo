from datetime import datetime, date
from typing import Optional
import uuid
from pydantic import EmailStr
from sqlmodel import SQLModel, Field, Relationship

# GASTOS 
class GastosBase(SQLModel):
    pago: str = Field(max_length = 50, min_length = 3, index = True)
    UTM: float = Field(gt = 0)
    peso_chileno: float = Field(gt = 0)
    titulo_pago: str = Field(max_length = 50, min_length = 3, index = True)
    porcentaje_pago: int = Field(ge = 0, index = True)
    fecha_pago: datetime = Field(index = True)
    fecha_pagado: datetime = Field(index = True)
    id_usuario: str = Field(max_length = 36, foreign_key = "usuario.id_usuario")

class GastosCreate(GastosBase):
    pass

class Gastos(GastosBase, table = True):
    __tablename__ = "gastos"
    id_gasto: Optional[int] = Field(default = None, primary_key = True)

    usuario: Optional["Usuario"] = Relationship(back_populates = "gastos")


# EVENTOS 
class EventosBase(SQLModel):
    titulo_evento: str = Field(max_length = 50, min_length = 3, index = True)
    cumplimiento: str = Field(max_length = 50, min_length = 3, index = True)
    duracion: int = Field(gt = 0)
    repeticion: int = Field(ge = 0, index = True)
    evento_inicio: datetime = Field(index = True)
    evento_termino: datetime = Field(index = True)
    id_usuario: str = Field(max_length = 36, foreign_key = "usuario.id_usuario")

class EventosCreate(EventosBase):
    pass

class Eventos(EventosBase, table = True):
    __tablename__ = "eventos"
    id_evento: Optional[int] = Field(default = None, primary_key = True)

    usuario: Optional["Usuario"] = Relationship(back_populates = "eventos")


# CHAT 
class ChatBase(SQLModel):
    contenido: str = Field(max_length = 5000, min_length = 3, index = True)
    envio: datetime = Field(index = True)
    filtro_aprobado: bool = Field(ge = 0)
    id_usuario: str = Field(max_length = 36, foreign_key = "usuario.id_usuario")

class ChatCreate(ChatBase):
    pass

class Chat(ChatBase, table = True):
    __tablename__ = "chat"
    id_msj: Optional[int] = Field(default = None, primary_key = True)

    usuario: Optional["Usuario"] = Relationship(back_populates = "chat")


# DOCS 
class DocsBase(SQLModel):
    url_arch: str = Field(max_length = 500)
    fecha_subida: datetime = Field(index = True)
    id_usuario: str = Field(max_length = 36, foreign_key = "usuario.id_usuario")

class DocsCreate(DocsBase):
    pass

class Docs(DocsBase, table = True):
    __tablename__ = "docs"
    id_doc: Optional[int] = Field(default = None, primary_key = True)

    usuario: Optional["Usuario"] = Relationship(back_populates = "docs")


# USUARIO 
class UsuarioBase(SQLModel):
    nombre: str = Field(max_length = 50, min_length = 3)
    email: EmailStr = Field(max_length = 50, min_length = 3)
    contrasena: str = Field(max_length = 255, min_length = 3)

class UsuarioCreate(UsuarioBase):
    pass

class UsuarioLogin(SQLModel):
    email: EmailStr
    contrasena: str

class UsuarioPublic(SQLModel):
    id_usuario: str
    nombre: str
    email: EmailStr

class Usuario(UsuarioBase, table = True):
    __tablename__ = "usuario"
    id_usuario: str = Field(default_factory=lambda: str(uuid.uuid4()), max_length = 36, primary_key = True)

    gastos: list[Gastos] = Relationship(back_populates = "usuario")
    eventos: list[Eventos] = Relationship(back_populates = "usuario")
    chat: list[Chat] = Relationship(back_populates = "usuario")
    docs: list[Docs] = Relationship(back_populates = "usuario")

#gt = greater than (mayor que)
#ge = greater than or equal to (mayor o igual que)
#lt = less than (menor que)
#le = less than or equal to (menor o igual que)
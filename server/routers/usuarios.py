import sys
from pathlib import Path
sys.path.append(str(Path(__file__).resolve().parent.parent))

from datetime import timedelta
from typing import Annotated

from fastapi import APIRouter, HTTPException, Depends, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlmodel import Session, select

from server.schemas import Usuario, UsuarioCreate, UsuarioLogin, UsuarioPublic
from server.database import get_session
from server.seguridad import (
    ACCESS_TOKEN_EXPIRE_MINUTES,
    Token,
    obtener_hash_contrasena,
    autenticar_usuario,
    crear_token_acceso,
    obtener_usuario_actual,
)

router = APIRouter(
    prefix = "/usuarios",
    tags = ["Usuarios"]
)

@router.post("/token", response_model = Token)
def login_para_token(
    form_data: Annotated[OAuth2PasswordRequestForm, Depends()],
    session: Session = Depends(get_session),
):

    usuario = autenticar_usuario(session, form_data.username, form_data.password)
    if not usuario:
        raise HTTPException(
            status_code = status.HTTP_401_UNAUTHORIZED,
            detail = "Correo o contraseña incorrectos",
            headers = {"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes = ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = crear_token_acceso(
        data = {"sub": usuario.id_usuario},
        expires_delta = access_token_expires,
    )
    return Token(access_token = access_token, token_type = "bearer")

@router.post("/login", response_model = Token)
def login(login_data: UsuarioLogin, session: Session = Depends(get_session)):
    usuario = autenticar_usuario(session, login_data.email, login_data.contrasena)
    if not usuario:
        raise HTTPException(
            status_code = status.HTTP_401_UNAUTHORIZED,
            detail = "Correo o contraseña incorrectos",
            headers = {"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes = ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = crear_token_acceso(
        data = {"sub": usuario.id_usuario},
        expires_delta = access_token_expires,
    )
    return Token(access_token = access_token, token_type = "bearer")

@router.get("/me", response_model = UsuarioPublic)
def leer_usuario_actual(
    usuario_actual: Annotated[Usuario, Depends(obtener_usuario_actual)],
):
    return usuario_actual

@router.get("/")
def get_usuarios(limit: int = 10, session: Session = Depends(get_session)):
    return session.exec(select(Usuario).limit(limit)).all()

@router.get("/{usuario_id}")
def get_usuario(usuario_id: str, session: Session = Depends(get_session)):
    usuario = session.get(Usuario, usuario_id)
    if not usuario:
        raise HTTPException(status_code = 404, detail = "Usuario no encontrado")
    return usuario

@router.post("/", response_model = UsuarioPublic, status_code = 201)
def create_usuario(usuario_data: UsuarioCreate, session: Session = Depends(get_session)):
    existente = session.exec(select(Usuario).where(Usuario.email == usuario_data.email)).first()
    if existente:
        raise HTTPException(status_code = 400, detail = "El email ya se encuentra registrado")

    hashed_password = obtener_hash_contrasena(usuario_data.contrasena)
    usuario = Usuario.model_validate(usuario_data, update = {"contrasena": hashed_password})
    session.add(usuario)
    session.commit()
    session.refresh(usuario)
    return usuario

@router.delete("/{usuario_id}")
def delete_usuario(usuario_id: str, session: Session = Depends(get_session)):
    usuario = session.get(Usuario, usuario_id)
    if not usuario:
        raise HTTPException(status_code = 404, detail = "Usuario no encontrado")
    session.delete(usuario)
    session.commit()
    return {"mensaje": "Usuario eliminado correctamente"}

@router.patch("/{usuario_id}")
def update_usuario(usuario_id: str, usuario_actualizado: UsuarioCreate, session: Session = Depends(get_session)):
    usuario_db = session.get(Usuario, usuario_id)
    if not usuario_db:
        raise HTTPException(status_code = 404, detail = "Usuario no encontrado")

    usuario_data = usuario_actualizado.model_dump(exclude_unset=True)
    if "contrasena" in usuario_data:
        usuario_data["contrasena"] = obtener_hash_contrasena(usuario_data["contrasena"])
    usuario_db.sqlmodel_update(usuario_data)
    session.add(usuario_db)
    session.commit()
    session.refresh(usuario_db)
    return usuario_db

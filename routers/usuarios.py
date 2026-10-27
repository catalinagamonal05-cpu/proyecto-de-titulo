import sys
from pathlib import Path
sys.path.append(str(Path(__file__).resolve().parent.parent))

from fastapi import APIRouter, HTTPException, Depends
from sqlmodel import Session, select
from schemas import Usuario, UsuarioCreate, UsuarioLogin, UsuarioPublic
from database import get_session

router = APIRouter(
    prefix = "/usuarios",
    tags = ["Usuarios"]
)

@router.get("/")
def get_usuarios(limit: int = 10, session: Session = Depends(get_session)):
    return session.exec(select(Usuario).limit(limit)).all()

@router.post("/login", response_model = UsuarioPublic)
def login(login_data: UsuarioLogin, session: Session = Depends(get_session)):
    usuario = session.exec(
        select(Usuario).where(Usuario.email == login_data.email)
    ).first()
    if usuario is None or usuario.contrasena != login_data.contrasena:
        raise HTTPException(
            status_code = 401,
            detail = "Correo o contraseña incorrectos",
        )
    return usuario

@router.get("/{usuario_id}")
def get_usuario(usuario_id: int, session: Session = Depends(get_session)):
    usuario = session.get(Usuario, usuario_id)
    if not usuario:
        raise HTTPException(status_code = 404, detail = "Usuario no encontrado")
    return usuario

@router.post("/", status_code = 201)
def create_usuario(usuario_data: UsuarioCreate, session: Session = Depends(get_session)):
    existente = session.exec(select(Usuario).where(Usuario.email == usuario_data.email)).first()
    if existente:
        raise HTTPException(status_code = 400, detail = "El email ya se encuentra registrado")

    usuario = Usuario.model_validate(usuario_data)
    session.add(usuario)
    session.commit()
    session.refresh(usuario)
    return usuario

@router.delete("/{usuario_id}")
def delete_usuario(usuario_id: int, session: Session = Depends(get_session)):
    usuario = session.get(Usuario, usuario_id)
    if not usuario:
        raise HTTPException(status_code = 404, detail = "Usuario no encontrado")
    session.delete(usuario)
    session.commit()
    return {"mensaje": "Usuario eliminado correctamente"}

@router.patch("/{usuario_id}")
def update_usuario(usuario_id: int, usuario_actualizado: UsuarioCreate, session: Session = Depends(get_session)):
    usuario_db = session.get(Usuario, usuario_id)
    if not usuario_db:
        raise HTTPException(status_code = 404, detail = "Usuario no encontrado")

    usuario_data = usuario_actualizado.model_dump(exclude_unset=True)
    usuario_db.sqlmodel_update(usuario_data)
    session.add(usuario_db)
    session.commit()
    session.refresh(usuario_db)
    return usuario_db

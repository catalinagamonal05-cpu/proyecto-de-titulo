from datetime import datetime, timedelta, timezone
from typing import Annotated
import os

from dotenv import load_dotenv
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt
from passlib.context import CryptContext
from sqlmodel import Session, select, Field, SQLModel

from database import get_session
from schemas import Usuario

load_dotenv()

SECRET_KEY = os.getenv("SECRET_KEY", "801df0a22778ad68b4186fa23d57f405294bf8b6e8bc17b885f6e6c502cbc008")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

class Token(SQLModel):
    access_token: str
    token_type: str

class TokenData(SQLModel):
    email: str | None = None


pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def verificar_contrasena(contrasena_plana: str, contrasena_hash: str) -> bool:
    return pwd_context.verify(contrasena_plana, contrasena_hash)

def obtener_hash_contrasena(contrasena: str) -> str:
    return pwd_context.hash(contrasena)

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="usuarios/token")

def crear_token_acceso(data: dict, expires_delta: timedelta | None = None) -> str:
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

def autenticar_usuario(session: Session, email: str, contrasena: str) -> Usuario | None:
    usuario = session.exec(select(Usuario).where(Usuario.email == email)).first()
    if not usuario:
        return None
    if not verificar_contrasena(contrasena, usuario.contrasena):
        return None
    return usuario

async def obtener_usuario_actual(
    token: Annotated[str, Depends(oauth2_scheme)],
    session: Session = Depends(get_session),
) -> Usuario:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="No se pudieron validar las credenciales",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        email: str = payload.get("sub")
        if email is None:
            raise credentials_exception
        token_data = TokenData(email=email)
    except JWTError:
        raise credentials_exception

    usuario = session.exec(
        select(Usuario).where(Usuario.email == token_data.email)
    ).first()
    if usuario is None:
        raise credentials_exception
    return usuario

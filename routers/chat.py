import sys
from pathlib import Path
sys.path.append(str(Path(__file__).resolve().parent.parent))

from fastapi import APIRouter, HTTPException, Depends
from sqlmodel import Session, select
from schemas import Chat, ChatCreate
from database import get_session

router = APIRouter(
    prefix = "/chat",
    tags = ["Chat"]
)

@router.get("/")
def get_msjs(limit: int = 10, session: Session = Depends(get_session)):
    return session.exec(select(Chat).limit(limit)).all()

@router.get("/{msj_id}")
def get_msj(msj_id: int, session: Session = Depends(get_session)):
    msj = session.get(Chat, msj_id)
    if not msj:
        raise HTTPException(status_code = 404, detail = "Mensaje no encontrado")
    return msj

@router.post("/", status_code = 201)
def create_msj(msj_data: ChatCreate, session: Session = Depends(get_session)):
    msj = Chat.model_validate(msj_data)
    session.add(msj)
    session.commit()
    session.refresh(msj)
    return msj
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).resolve().parent.parent))

from fastapi import APIRouter, HTTPException, Depends
from sqlmodel import Session, select
from schemas import Eventos, EventosCreate
from database import get_session

router = APIRouter(
    prefix = "/eventos",
    tags = ["Eventos"]
)

@router.get("/")
def get_eventos(limit: int = 10, session: Session = Depends(get_session)):
    return session.exec(select(Eventos).limit(limit)).all()

@router.get("/{evento_id}")
def get_evento(evento_id: int, session: Session = Depends(get_session)):
    evento = session.get(Eventos, evento_id)
    if not evento:
        raise HTTPException(status_code = 404, detail = "Evento no encontrado")
    return evento

@router.post("/", status_code = 201)
def create_evento(evento_data: EventosCreate, session: Session = Depends(get_session)):
    evento = Eventos.model_validate(evento_data)
    session.add(evento)
    session.commit()
    session.refresh(evento)
    return evento

@router.delete("/{evento_id}")
def delete_evento(evento_id: int, session: Session = Depends(get_session)):
    evento = session.get(Eventos, evento_id)
    if not evento:
        raise HTTPException(status_code = 404, detail = "Evento no encontrado")
    session.delete(evento)
    session.commit()
    return {"message": "Evento eliminado correctamente"}

@router.patch("/{evento_id}")
def update_evento(evento_id: int, evento_actualizado: EventosCreate, session: Session = Depends(get_session)):
    evento_db = session.get(Eventos, evento_id)
    if not evento_db:
        raise HTTPException(status_code = 404, detail = "Evento no encontrado")

    evento_data = evento_actualizado.model_dump(exclude_unset=True)
    evento_db.sqlmodel_update(evento_data)
    session.add(evento_db)
    session.commit()
    session.refresh(evento_db)
    return evento_db
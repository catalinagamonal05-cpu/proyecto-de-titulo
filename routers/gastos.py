import sys
from pathlib import Path
sys.path.append(str(Path(__file__).resolve().parent.parent))

from fastapi import APIRouter, HTTPException, Depends
from sqlmodel import Session, select
from schemas import Gastos, GastosCreate
from database import get_session

router = APIRouter(
    prefix = "/gastos",
    tags = ["Gastos"]
)

@router.get("/")
def get_gastos(limit: int = 10, session: Session = Depends(get_session)):
    return session.exec(select(Gastos).limit(limit)).all()

@router.get("/{gasto_id}")
def get_gasto(gasto_id: int, session: Session = Depends(get_session)):
    gasto = session.get(Gastos, gasto_id)
    if not gasto:
        raise HTTPException(status_code = 404, detail = "Gasto no encontrado")
    return gasto

@router.post("/", status_code = 201)
def create_gasto(gasto_data: GastosCreate, session: Session = Depends(get_session)):
    gasto = Gastos.model_validate(gasto_data)
    session.add(gasto)
    session.commit()
    session.refresh(gasto)
    return gasto

@router.delete("/{gasto_id}")
def delete_gasto(gasto_id: int, session: Session = Depends(get_session)):
    gasto = session.get(Gastos, gasto_id)
    if not gasto:
        raise HTTPException(status_code = 404, detail = "Gasto no encontrado")
    session.delete(gasto)
    session.commit()
    return {"message": "Gasto eliminado correctamente"}

@router.patch("/{gasto_id}")
def update_gasto(gasto_id: int, gasto_actualizado: GastosCreate, session: Session = Depends(get_session)):
    gasto_db = session.get(Gastos, gasto_id)
    if not gasto_db:
        raise HTTPException(status_code = 404, detail = "Gasto no encontrado")

    gasto_data = gasto_actualizado.model_dump(exclude_unset=True)
    gasto_db.sqlmodel_update(gasto_data)
    session.add(gasto_db)
    session.commit()
    session.refresh(gasto_db)
    return gasto_db
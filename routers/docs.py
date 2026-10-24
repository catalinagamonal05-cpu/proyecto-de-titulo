import sys
from pathlib import Path
sys.path.append(str(Path(__file__).resolve().parent.parent))

from fastapi import APIRouter, HTTPException, Depends
from sqlmodel import Session, select
from schemas import Docs, DocsCreate
from database import get_session

router = APIRouter(
    prefix = "/docs",
    tags = ["Docs"]
)

@router.get("/")
def get_docs(limit: int = 10, session: Session = Depends(get_session)):
    return session.exec(select(Docs).limit(limit)).all()

@router.get("/{doc_id}")
def get_doc(doc_id: int, session: Session = Depends(get_session)):
    doc = session.get(Docs, doc_id)
    if not doc:
        raise HTTPException(status_code = 404, detail = "Documento no encontrado")
    return doc

@router.post("/", status_code = 201)
def create_doc(doc_data: DocsCreate, session: Session = Depends(get_session)):
    doc = Docs.model_validate(doc_data)
    session.add(doc)
    session.commit()
    session.refresh(doc)
    return doc

@router.delete("/{doc_id}")
def delete_doc(doc_id: int, session: Session = Depends(get_session)):
    doc = session.get(Docs, doc_id)
    if not doc:
        raise HTTPException(status_code = 404, detail = "Documento no encontrado")
    session.delete(doc)
    session.commit()
    return {"message": "Documento eliminado correctamente"}

@router.patch("/{doc_id}")
def update_doc(doc_id: int, doc_actualizado: DocsCreate, session: Session = Depends(get_session)):
    doc_db = session.get(Docs, doc_id)
    if not doc_db:
        raise HTTPException(status_code = 404, detail = "Documento no encontrado")

    doc_data = doc_actualizado.model_dump(exclude_unset=True)
    doc_db.sqlmodel_update(doc_data)
    session.add(doc_db)
    session.commit()
    session.refresh(doc_db)
    return doc_db
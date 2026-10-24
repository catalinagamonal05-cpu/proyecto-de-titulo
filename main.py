from fastapi import FastAPI
from database import engine, create_db_and_tables, get_session
import schemas

from routers.usuarios import router as usuarios_router
from routers.gastos import router as gastos_router
from routers.eventos import router as eventos_router
from routers.chat import router as chat_router
from routers.docs import router as docs_router

app = FastAPI(title="Nestly")

app.include_router(usuarios_router)
app.include_router(gastos_router)
app.include_router(eventos_router)
app.include_router(chat_router)
app.include_router(docs_router)

@app.get("/")
def home():
    return {"message": "API Nestly funcionando correctamente"}

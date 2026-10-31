from fastapi import FastAPI
from server.database import engine, create_db_and_tables, get_session
import server.schemas as schemas

from server.routers.usuarios import router as usuarios_router
from server.routers.gastos import router as gastos_router
from server.routers.eventos import router as eventos_router
from server.routers.chat import router as chat_router
from server.routers.docs import router as docs_router

app = FastAPI(title="Nestly")

app.include_router(usuarios_router)
app.include_router(gastos_router)
app.include_router(eventos_router)
app.include_router(chat_router)
app.include_router(docs_router)

@app.get("/")
def home():
    return {"message": "API Nestly funcionando correctamente"}

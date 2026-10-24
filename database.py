from sqlmodel import SQLModel, create_engine, Session

url_db = "mysql+pymysql://root:NaRx150515!@localhost:3306/nestly"
engine = create_engine(url_db, echo = True)

def create_db_and_tables():
    SQLModel.metadata.create_all(engine)

def get_session():
    with Session(engine) as session:
        yield session

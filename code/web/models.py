# -*- coding: utf-8 -*-

# sqlacodegen mysql+pymysql://root:root@127.0.0.1:3306/share > models.py
#                                                            
from sqlalchemy import Column, Integer, String
from sqlalchemy import create_engine
from .database import Base
                                                              
class ShareLike(Base):
    __tablename__ = 'share_like'                                                      
    id = Column(Integer, primary_key=True, autoincrement=True)
    categoryId = Column(Integer, name="category_id", unique=True)
    code = Column(String(8))
    name = Column(String(20))

class ShareLikeCategory(Base):
    __tablename__ = 'share_like_category'
    id = Column(Integer, primary_key=True,autoincrement=True)
    name = Column(String(50), unique=True)

class Tactics(Base):
    __tablename__ = 'tactics'
    id = Column(Integer, primary_key=True, autoincrement=True)
    owner = Column(String(50))
    name = Column(String(50))
    source = Column(String(256), unique=True)
    doc = Column(String(256), unique=True)



class TacticsInput(Base):
    __tablename__ = 'tactics_input'
    id = Column(Integer, primary_key=True, autoincrement=True) 
    tacticsId = Column(String(50))
    name = Column(String(50))
    type = Column(String(50))
    title = Column(String(50))
    defual = Column(String(50))




if __name__ == '__main__':
    engine = create_engine('mysql+pymysql://root:root@127.0.0.1:3306/share', convert_unicode=True)
    Base.metadata.create_all(bind=engine)

                                                              
    
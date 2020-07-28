# -*- coding: utf-8 -*-
                                                              
from sqlalchemy import Column, Integer, String
from sqlalchemy import create_engine
from database import Base
                                                              
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

    def __init__(self, owner, name,  source, doc):
        self.owner = owner
        self.name = name
        self.source = source
        self.doc = doc

class TacticsInput(Base):
    __tablename__ = 'tactics_input'
    id = Column(Integer, primary_key=True, autoincrement=True) 
    tacticsId = Column(String(50),name="tactics_id")
    name = Column(String(50))
    title = Column(String(50))
    defual = Column(String(50))

    def __init__(self, tacticsId, name,  title, defual):
        self.tacticsId = tacticsId
        self.name = name
        self.title = title
        self.defual = defual


if __name__ == '__main__':
    engine = create_engine('sqlite:////Users/admin/share/sqllite/share.db', convert_unicode=True)
    Base.metadata.create_all(bind=engine)

                                                              
    
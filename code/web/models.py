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
    id = Column(Integer, primary_key=True)
    name = Column(String(50), unique=True)

if __name__ == '__main__':
    engine = create_engine('sqlite:////Users/admin/share/sqllite/share.db', convert_unicode=True)
    Base.metadata.create_all(bind=engine)

                                                              
    
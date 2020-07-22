# -*- coding: utf-8 -*-
                                                              
from sqlalchemy import Column, Integer, String
from database import Base
                                                              
class ShareLike(Base):
    __tablename__ = 'share_like'                                                      
    id = Column(Integer, primary_key=True)
    name = Column(String(50), unique=True)
    email = Column(String(120), unique=True)

class ShareCategory
    __tablename__ = 'share_category'
    id = Column(Integer, primary_key=True,)
                                                              
    
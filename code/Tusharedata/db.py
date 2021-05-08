import os,time
from sqlalchemy import Column, Integer, String, Float
from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session, sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from config import dataPath as root
from file import mkdir

                                                            
dbpath = root+"/sqlite/tushare.db"
engine = create_engine('sqlite:///{0}'.format(dbpath), echo=True)

session = scoped_session(sessionmaker(autocommit=False,
                                         autoflush=False,
                                         bind=engine))

# 为声明性类定义构造基类                                        
Base = declarative_base()
Base.query = session.query_property()


class DataCache(Base):
    __tablename__ = 'data_cache'                                                      
    id = Column(Integer, primary_key=True, autoincrement=True)
    key = Column(String(), comment='keu')
    value = Column(String(), comment='value')

Base.metadata.create_all(bind=engine)

    

import os,time
from sqlalchemy import Column, Integer, String, Float
from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session, sessionmaker
from sqlalchemy.ext.declarative import declarative_base
                                                                
dbpath = "./data/sqlite/sdata.db"
engine = create_engine('sqlite:///{0}'.format(dbpath), echo=True)

session = scoped_session(sessionmaker(autocommit=False,
                                         autoflush=False,
                                         bind=engine))

# 为声明性类定义构造基类                                        
Base = declarative_base()
Base.query = session.query_property()


class SdataUpdateTime(Base):
    __tablename__ = 'sdata_update_time'                                                      
    id = Column(Integer, primary_key=True, autoincrement=True)
    code = Column(String(16), comment='股票编码')
    suffix = Column(String(8), comment='股票后缀')
    create_time = Column(Float, default= time.time(), comment='创建时间')
    change_time = Column(Float, default= time.time(), comment='修改时间')

Base.metadata.create_all(bind=engine)

    

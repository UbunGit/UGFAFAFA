#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os                                                             
from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session, sessionmaker
from sqlalchemy.ext.declarative import declarative_base
                                                                
# engine = create_engine('mysql+pymysql://root:root@127.0.0.1:3306/share', convert_unicode=True) # 创建数据库引擎( 当前目录下保存数据库文件) 

path = os.path.join(os.getcwd(),"data","sqlite.db")
engine = create_engine('sqlite:///{0}'.format(path), echo=True)

session = scoped_session(sessionmaker(autocommit=False,
                                         autoflush=False,
                                         bind=engine))
Base = declarative_base()
Base.query = session.query_property()
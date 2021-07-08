#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os,time,json
from datetime import datetime
from sqlalchemy import Column, Integer, String, Float,Date,DateTime
from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session, sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from config import dataPath as root
from file import mkdir

                                                            
dbpath = root+"/sqlite/Analyse.db?check_same_thread=true"
engine = create_engine('sqlite:///{0}'.format(dbpath), echo=True)

session = scoped_session(sessionmaker(autocommit=False,
                                         autoflush=False,
                                         bind=engine))

# 为声明性类定义构造基类                                        
Base = declarative_base()
Base.query = session.query_property()

# 策略信息
class AnalyseCache(Base):
    __tablename__ = 'analyse_cache'                                                      
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String)
    parameter = Column(String)
    begin = Column(DateTime)
    end = Column(DateTime)
    codes = Column(String)
    result = Column(String)
    create_time = Column(DateTime)
    change_time = Column(DateTime)
    # 先判断是否存在，创建分析缓存数据
    def create(self):
  
        analyseCache = self.query.filter_by(name=self.name,parameter=str(self.parameter),begin=self.begin,end=self.end,codes=str(self.codes)).first()
        if not analyseCache:
            analyseCache = self
            analyseCache.parameter = str(self.parameter)
            analyseCache.codes = str(self.codes)
            analyseCache.change_time = datetime.now()
            analyseCache.create_time = datetime.now()
            session.add(analyseCache)
            session.flush()
            session.commit()
            
        self.id = analyseCache.id
        return self
    
    def search(self,name):
        acc_list = []
        query_all = self.query.filter_by(name=name).all()
        for item in query_all:
            dic = item.__dict__
            dic["begin"] = str(item.begin)
            dic["end"] = str(item.end)
            dic["parameter"] = eval(item.parameter)
            dic["codes"] = eval(item.codes)
            dic["createTime"] = str(item.create_time)
            dic["changeTime"] = str(item.change_time)
            dic.pop('_sa_instance_state')
            
            acc_list.append(dic)
        return acc_list
# bs记录
class AnalyseBSRecords(Base):
    __tablename__ = 'analyse_bs_records'                                                      
    id = Column(Integer, primary_key=True, autoincrement=True)
    cache_id = Column(Integer)
    code = Column(String)
    date = Column(DateTime)
    count = Column(Integer)
    price = Column(Float)
    free = Column(Float)
    type = Column(Integer) # 1买入 2 卖出

    def create(self):
        records_id=0
        records = self
        session.add(records)
        session.flush()
        session.commit()
        records_id = records.id
        return records_id

    def delete(self, cache_id):
        records = self.query.filter_by(cache_id=cache_id).delete(synchronize_session=False)
        session.commit()

    def search(self,cache_id,code,type=None):
        list = []
        if type == None:
            query_all = self.query.filter_by(cache_id=cache_id, code=code).all()
        else:
            query_all = self.query.filter_by(cache_id=cache_id, code=code, type=type).all()

        for item in query_all:
            dic = item.__dict__
            dic["id"] = item.id
            dic["cacheId"] = item.cache_id
            dic["code"] = item.code
            dic["date"] = str(item.date).strftime("%Y%m%d")
            dic["count"] = item.count
            dic["price"] = item.price
            dic["free"] = item.free
            dic["type"] = item.type
            dic.pop('cache_id')
            dic.pop('_sa_instance_state')
            list.append(dic)
        return list


# 持仓记录
class AnalyseZoneRecords(Base):
    __tablename__ = 'analyse_zone_records'                                                      
    id = Column(Integer, primary_key=True, autoincrement=True)
    cache_id = Column(Integer)
    code = Column(String)
    begin = Column(DateTime)
    end = Column(DateTime)
    earnings = Column(Float)
    earnings_v = Column(Float)

    def delete(self, cache_id):
        records = self.query.filter_by(cache_id=cache_id).delete(synchronize_session=False)
        session.commit()
    def search(self,cache_id,code):
        return  self.query.filter_by(cache_id=cache_id, code=code).all()



Base.metadata.create_all(bind=engine)



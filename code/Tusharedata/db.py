import os,time,sys
from datetime import datetime
from sqlalchemy import *
from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session, sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from config import dataPath as root
from file import mkdir

                                                            
dbpath = root+"/sqlite/tushare.db?check_same_thread=true"
engine = create_engine('sqlite:///{0}'.format(dbpath), echo=True)
metadata = MetaData(engine)
session = scoped_session(sessionmaker(autocommit=False,
                                         autoflush=False,
                                         bind=engine))


# 为声明性类定义构造基类                                        
Base = declarative_base()
Base.query = session.query_property()

def multipleDic(list):
    news_list = []
    for i in list:
        dic = i.to_dic()
        news_list.append(dic)
    return news_list


class DataCache(Base):
    __tablename__ = 'data_cache'                                                      
    id = Column(Integer, primary_key=True, autoincrement=True)
    key = Column(String(), comment='key')
    value = Column(String(), comment='value')

# 股票列表
class StockBasic(Base):

    __tablename__ = 'stock_basic'

    code=Column(String(), primary_key=True)
    name=Column(String(), comment='股票名称')
    area=Column(String(),  comment='地区')
    industry=Column(String(),  comment='所属行业')
    market=Column(String(),  comment='市场类型（主板/创业板/科创板/CDR')
    changeTime=Column(DateTime, comment='更新时间')
  

    def to_dic(self):
        new_dic = self.__dict__
        new_dic.pop('_sa_instance_state')
        new_dic["changeTime"] = self.changeTime.strftime("%Y%m%d")
        return new_dic
    # 更新股票列表
    def to_db(self,datas,ignore=True):
        try:
            for x in datas:
                x["changeTime"] = datetime.now()
            prefix = 'OR IGNORE' if ignore==True else 'OR REPLACE'
            table = Table('stock_basic', metadata, autoload=True)
            i = table.insert().prefix_with('OR IGNORE')
            stmt = session.execute(i, datas)
            session.commit()
        except:
            session.rollback()
        finally:
            session.close()
    
    # 查找晚与changeTime包含keyword的数据
    def fitter(self, keyword="", changeTime=""):
        changeTime = changeTime if changeTime!="" else "17500101"
        reqster= session.query(StockBasic).filter(
            StockBasic.changeTime > datetime.strptime(changeTime,'%Y%m%d')
            ).filter(
                StockBasic.code.like("%"+keyword+"%" or StockBasic.name.like("%"+keyword+"%" ))
            ).all() 
 
        rlist = []
        for item in reqster:
            rlist.append(item.to_dic())
        return rlist

    # 获取最后一个更新数据
    def last(self, column="changeTime", isdesc=True):
        try:
            if isdesc==True:
                return session.query(StockBasic).order_by(desc(column)). first()
            else:
                return session.query(StockBasic).order_by(column). first()
        finally:
            session.close()

# 基金列表
class ETFBasic(Base):
    __tablename__ = 'etf_basic'

    code=Column(String(), primary_key=True)
    name=Column(String(), comment='ETF名称')
    changeTime=Column(DateTime, comment='更新时间')

    def to_dic(self):
        new_dic = self.__dict__
        new_dic.pop('_sa_instance_state')
        new_dic["changeTime"] = self.changeTime.strftime("%Y%m%d")
        return new_dic

    def to_db(self, datas):
        try:
            for x in datas:
                x["changeTime"] = datetime.now()
            table = Table('etf_basic', metadata, autoload=True)
            i = table.insert().prefix_with('OR IGNORE')
            session.execute(i, datas)
            session.commit()
        except Exception as e:
            print(e)
            session.rollback()
        finally:
            session.close()

     # 获取最后一个
    
     # 查找晚与changeTime包含keyword的数据
    
    def fitter(self, keyword="", changeTime=""):
        changeTime = changeTime if changeTime!="" else "17500101"
        reqster= session.query(ETFBasic).filter(
            ETFBasic.changeTime > datetime.strptime(changeTime,'%Y%m%d')
            ).filter(
                ETFBasic.code.like("%"+keyword+"%" or ETFBasic.name.like("%"+keyword+"%" ))
            ).all() 
 
        rlist = []
        for item in reqster:
            rlist.append(item.to_dic())
        return rlist

    def last(self, column="changeTime", isdesc=True):
        if isdesc==True:
            return session.query(ETFBasic).order_by(desc(column)). first()
        else:
            return session.query(ETFBasic).order_by(column).first()


Base.metadata.create_all(bind=engine)



    

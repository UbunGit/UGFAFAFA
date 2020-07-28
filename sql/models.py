# coding: utf-8
from sqlalchemy import Column, String
from sqlalchemy.dialects.mysql import BIGINT
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()
metadata = Base.metadata


class ShareLike(Base):
    __tablename__ = 'share_like'
    __table_args__ = {'comment': '股票收藏表'}

    id = Column(BIGINT(20), primary_key=True)
    category_id = Column(BIGINT(20), comment='分类id')
    code = Column(String(8), comment='代码')
    name = Column(String(50), comment='名称')


class ShareLikeCategory(Base):
    __tablename__ = 'share_like_category'
    __table_args__ = {'comment': '股票收藏分类表'}

    id = Column(BIGINT(20), primary_key=True)
    name = Column(String(50), comment='名称')


class Tactic(Base):
    __tablename__ = 'tactics'
    __table_args__ = {'comment': '策略表'}

    id = Column(BIGINT(20), primary_key=True)
    owner = Column(String(50), comment='拥有者')
    name = Column(String(50), comment='名称')
    source = Column(String(50), comment='源码路径')
    doc = Column(String(50), comment='文档路径')


class TacticsInput(Base):
    __tablename__ = 'tactics_input'
    __table_args__ = {'comment': '策略入参表'}

    id = Column(BIGINT(20), primary_key=True)
    tacticsId = Column(BIGINT(20), nullable=False, comment='策略id')
    name = Column(String(50), comment='入参名称')
    title = Column(String(50), comment='入参key')
    defual = Column(String(50), comment='入参默认值')

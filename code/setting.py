#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# 初始化项目中用到的表
import os
from sqlalchemy import create_engine
from sqlalchemy import Column, Date, Integer, String, ForeignKey
from sqlalchemy.ext.declarative import declarative_base

from database import  Base, engine
from models import Tactics

Base.metadata.create_all(bind=engine)


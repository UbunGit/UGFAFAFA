#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
'''

from main import db

# 定义策略Tactics对象:
class Tactics(db.Model):
    # 表的名字:
    __tablename__ = 'tactics'
    # 表的结构:
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50))
    categories = db.Column(db.Integer)
    remark = db.Column(db.String(512))

    def __init__(self, name, categories,remark):
        self.name = name
        self.categories = categories
        self.remark = remark

   
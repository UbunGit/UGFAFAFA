#!/usr/bin/env python3
# -*- coding: utf-8 -*-

class Strategy:
    '''
    策略父类
    '''
    def __init__(self):
        self.name = ""
        self.signal="signal"

    def next(self,df):
        return 100, df["close"], 0, 0
    
 


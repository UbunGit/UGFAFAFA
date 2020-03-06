#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import tushare as ts
import numpy
import pandas
import os

###
## 股票列表
###
class share:
    cdata = None # 股票数据
    code = None # 股票数据
    def __init__(self, code, star= None, end= None):
        #根据股票编码初始化数据
        self.code = code
        self.cdata = ts.get_hist_data(code)
        print(self.cdata)

    def save(self):
        self.cdata.to_csv('~/share/data/'+str(self.code)+'.csv')
        print("保存"+str(self.code))

###
## 股票列表
###
filepath = '~/share/data/basics.csv'
class shares:
    basics = None # 股票列表
    def __init__(self):
        temdata = None
        if os.path.exists(filepath):
            temdata = pandas.read_csv(filepath)
        if temdata is None:
            temdata = ts.get_stock_basics()
            temdata.to_csv(filepath)
        self.basics = temdata



    def run(self):
        codes = numpy.array(self.basics.index)
        # for i in range(len(codes)):
        for i in range(2):
            temshare = share(code=codes[i])
            temshare.save()


if __name__ == '__main__':
    center = shares()
    center.run()
    print(center.basics)

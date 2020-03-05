#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import tushare as ts
import numpy

class timer:
    basics = None # 股票列表
    def __init__(self):
        self.basics = ts.get_stock_basics()
    # 保存数据到cvs
    def saveHistory(self, code):

        print("保存数据到cvs")
    def begindate(self, code):
        print("获取要获取的开始时间")
        return "2020-01-01"

    def run(self):
        codes = numpy.array(self.basics.index)
        for i in range(len(codes)):
            befindate = self.begindate(codes[i])


if __name__ == '__main__':
    center = timer()
    center.run()
    print(center.basics)

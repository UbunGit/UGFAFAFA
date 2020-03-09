#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import tushare as ts

class timer:
    basics = None # 股票列表
    def __init__(self):
        self.basics = ts.get_stock_basics()

if __name__ == '__main__':
    center = timer()
    print(center.basics)

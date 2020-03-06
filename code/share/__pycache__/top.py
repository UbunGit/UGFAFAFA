#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import tushare as ts

date = '2020-03-04'
def top():
    dt = ts.top_list(date)
    dt.to_csv('~/share/tem/top_'+date+'.csv')

def cap_tops():
    dt = ts.cap_tops()
    dt.to_csv('~/share/tem/cap_top_'+date+'.csv')

cap_tops()
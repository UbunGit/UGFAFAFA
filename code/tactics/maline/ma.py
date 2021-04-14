#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import talib as tl

# 计算均线max是否上穿may
# data 股票数据 
# max 均线1
# max 均线2
def matype(data,max,may):
    df = data
    df['max'] = tl.MA(df['close'],timeperiod = max)
    df['may'] = tl.MA(df['close'],timeperiod = may)
    df['max_'] = df['max'].shift(-1)
    df['max+'] = df['max'].shift(1)
    df['may_'] = df['may'].shift(-1)
    df['may+'] = df['may'].shift(1)
    df['mat'] =  ((df['max_'] <= df['may_']) & (df['max+'] >= df['may+']))
    data['mat'] = df['mat']

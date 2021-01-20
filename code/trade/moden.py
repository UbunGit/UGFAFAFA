#!/usr/bin/env python3
# -*- coding: utf-8 -*-

class StoreData:
    id =  0 # 股票代码
    num = 0 # 买入数量
    bdate = None # 买入时间
    sdate = None # 卖出时间
    bprice = 0.00
    sprice = 0.00
    isSeller = False
    inday = 0 # 持股天数
    fee = 0.00 # 手续费


class ShareData:
    code=None
    date=None
    open=None
    high=None
    low=None
    close=None
    pre_close=None
    change=None
    pct_chg=None
    vol=None
    amount=None
    MACD=None
    DEA=None
    DIFF=None
    ma30=None
#!/usr/bin/env python3
# -*- coding: utf-8 -*-


import akshare as ak
import pandas as pd
from config import dataPath as root
from unit import isneedupdate

def trade_date_hist():
    df = ak.tool_trade_date_hist_sina()
    return df

print(trade_date_hist())

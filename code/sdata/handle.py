#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import logging
logging.basicConfig(level=logging.NOTSET)  # 设置日志级别

def shift(data,itmes,axis):
    _data = data
    for item in itmes:
        for axi in axis:
            sname = item+'_'+str(axi)
            data[sname] = _data[item].shift(-axi)
    return
            

#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys, json

from .damrey import * 
from .maline import * 

# 返回策略列表
def analyses():
    return  json.dumps(
        [
            damrey.info(),
            maline.info()
        ]
        , ensure_ascii=False
    )
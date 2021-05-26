#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys, json

from .damrey import * 
from .haikui import * 

# 返回策略列表
def analyses():
    return  [
                damrey.info(),
                haikui.info()
            ] 
    
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys, json

from .damrey import info as  damreyInfo
from .haikui import info as  haikuiInfo

# 返回策略列表
def analyses():
    return  [
                damreyInfo(),
                haikuiInfo()
            ]

class Analyse:
    
    def info(self):
        # 获取策略简介
        pass
    
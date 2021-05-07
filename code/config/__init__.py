#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import configparser



#获取config配置文件
def getConfig(section, key):
    config = configparser.ConfigParser()
    path = os.path.split(os.path.realpath(__file__))[0] + '/config.conf'
    config.read(path)
    return config.get(section, key)

dataPath = getConfig("path","dataPath")
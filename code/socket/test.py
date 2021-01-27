#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os,sys
import logging
import importlib
from flask_socketio import SocketIO,send,emit 
sys.path.append("..")
print(sys.path)
class Trade:
    shares = []

    def trade(self, id, param):
        '''
        id 
        '''
        mod = importlib.import_module("tactics.{}".format(id))
        self.shares = mod.setup(param)
        for item in self.shares:
            data = mod.buy(item)
            print(data)


if __name__ == '__main__':
     Trade().trade(
            "test", param={
                'code': "300022.SZ",
                'begin': '20200507',
                'end': '20200607',
                'money': 10000
            })

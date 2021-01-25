#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import logging
import importlib

sys.path.append("./code")


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

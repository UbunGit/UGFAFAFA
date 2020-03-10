#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import tushare as ts
import numpy
import pandas
import time
from trade import shares,share

formattime = (time.strftime('%Y-%m-%d',time.localtime(time.time())))
def run():
    l_shares = shares()
    fitters = l_shares.basics
    codes = numpy.array(fitters.index)
    sharlist = pandas.DataFrame()
    # for i in range(len(codes)):
    for i in range(len(codes)):
        temshare = share(codes[i],'2020-01-01', formattime)
        sharlist = sharlist.append(temshare.cdata[-1:])
        print(codes[i],"[",i,"/",len(codes),"]")
        time.sleep(1)
    sharlist["code"]= codes 
    print(sharlist)
        

if __name__ == '__main__':
    # run()
    print(formattime)

#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import tushare as ts
import numpy
import pandas
import time
from trade import shares,share

# formattime = (time.strftime('%Y-%m-%d',time.localtime(time.time())))
formattime = '2020-03-02'
def run():
    l_shares = shares()
    fitters = l_shares.basics
    codes = numpy.array(fitters.index)
    names = numpy.array(fitters.name)
    sharlist = pandas.DataFrame()
    sharecodes = []
    sharenames = []
    for i in range(len(codes)):
        temshare = share(codes[i],'2020-01-01', formattime)
        if temshare.cdata is not None:
            sharlist = sharlist.append(temshare.cdata[-1:])
            sharecodes.append(codes[i])
            sharenames.append(names[i])
        sharlist["code"]= sharecodes 
        sharlist["name"]= sharenames 

        print(codes[i],"[",i,"/",len(codes),"]")
        sharlist.to_csv("~/share/tem/shares_"+formattime+".csv")
    print(sharlist)
        

if __name__ == '__main__':
    run()

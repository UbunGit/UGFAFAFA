#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import tushare as ts
import numpy
import pandas
import time
from trade import shares,share

formattime = (time.strftime('%Y-%m-%d',time.localtime(time.time())))
# formattime = '2020-03-03'
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
        print(codes[i],names[i],"[",i,"/",len(codes),"]")
        if temshare.cdata is not None and len(temshare.cdata)>1:
            try:
                sharlist = sharlist.append(temshare.cdata[-1:])
                sharecodes.append(codes[i])
                sharenames.append(names[i])
                sharlist["code"]= sharecodes 
                sharlist["name"]= sharenames 
                sharlist.to_csv("~/share/tem/shares_"+formattime+".csv")
            except Exception as e:
                
                print('except:', e)
                print("codes:%s",len(sharlist["code"]))
                print("name:%s",len(sharlist["name"]))
                print("sharenames.length%s",len(sharenames))
                
    print(sharlist)
        

if __name__ == '__main__':
    run()
    

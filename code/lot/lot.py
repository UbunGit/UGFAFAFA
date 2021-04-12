#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# 彩票
import pandas
import logging
import numpy
logpath = '../data/tacticsm5.log'


data = pandas.read_csv('../data/lot_zhcw_ssq.csv', header=None)
data = data.sort_values(by=1)
print(data)


def createData(cdata):
    lists = numpy.array(cdata[3])
    lists1 = numpy.array(cdata[4])
    lists2 = numpy.array(cdata[5])
    lists3 = numpy.array(cdata[6])
    lists4 = numpy.array(cdata[7])
    lists5 = numpy.array(cdata[8])
    lists = numpy.append(lists, lists1)
    lists = numpy.append(lists, lists2)
    lists = numpy.append(lists, lists3)
    lists = numpy.append(lists, lists4)
    lists = numpy.append(lists, lists5)
    enddata = []
    for i in range(1, 33):
        sumnum = numpy.sum(lists==i)
        enddata.append(sumnum)
    print(enddata)

def cut(data):
    for i in range(len(data)-4):
        createData(data[i:i+12])


cut(data)
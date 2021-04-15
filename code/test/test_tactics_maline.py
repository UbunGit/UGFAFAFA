#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os,sys
import logging
sys.path.append('./code')

# for item in sys.path:
#     print (os.path.abspath(item))

from sdata  import sd_reload,shift
from tactics import matype

datapath = "./data/tem"
code = '002655'
type = 'SZ'
data = sd_reload(code=code,suffix=type)
shift(data,['close'],[10,30,20])

endata = matype(data,5,30)
logging.debug(endata)
endata['close_10v'] = (endata['close_10'] / endata['close'] *10)
endata['close_30v'] = (endata['close_30'] / endata['close'] *10)
endata['close_20v'] = (endata['close_20'] / endata['close'] *10)
adata = endata.loc[: , ['date','close','close_10v','close_30v','close_20v']]
logging.debug(adata)

grdf = endata.groupby("close_30v")['date'].count()
logging.debug(grdf)
filepath = os.path.join(datapath,'testresult'+'.csv')
grdf.to_csv(filepath)
# logging.debug(data)
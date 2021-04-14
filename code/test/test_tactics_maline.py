#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os,sys
import logging
sys.path.append('./code')

# for item in sys.path:
#     print (os.path.abspath(item))

from sdata  import sd_reload
from tactics import matype

code = '601138'
type = 'SH'
data = sd_reload(code=code,suffix=type)
matype(data,5,30)
logging.debug(data)
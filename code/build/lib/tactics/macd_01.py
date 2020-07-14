#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from trade import trade
import numpy
import sys
import logging
import os
logging.basicConfig(level=logging.NOTSET)  # 设置日志级别

# 根据macd值买入优化v1.0.0 2020.7.14
# 步骤：
# 1.获取 MACD DEA，DIFF
# 2.如果 MACD>0 --其实也就是20日均线开始向上掉头，判断是否可以买入
# 3.以第一次买入价制定买卖价格11个档位 -- 30日均线 向上5个，向下五个 各以5%为阶梯
# 4.循环判断买入条件
#   1 MACD>0
#   2 b 股价在30日均线1%以内 
#   3 股价在当前档位没有持仓
# 5. 卖出条件
#   1 股价超过持仓最低档卖出价



if __name__ == '__main__':
    logging.info("根据macd值买入优化v1.0.0 2020.7.14")
    logging.info("args:%s",sys.argv)
    amount = '10000'
    start = '2019-10-01'
    end = '2020-12-01'
    tcode = '300022'

    if len(sys.argv)>1:
        tcode = sys.argv[1]
    if len(sys.argv)>2:
        amount = sys.argv[2]
    if len(sys.argv)>3:
        start = sys.argv[3]
    if len(sys.argv)>4:
        end = sys.argv[4]
    logging.info("begin tcode:%s amount:%s start:%s end:%s",tcode,amount,start,end)
    cent = trade(tcode, begin=start, end=end, balance=amount)
    
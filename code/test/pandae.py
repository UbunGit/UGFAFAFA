import numpy as np
import pandas as pd
import sys
import logging
import os
logging.basicConfig(level=logging.NOTSET)  # 设置日志级别

plandf = pd.DataFrame()

def makeplan(price):

    logging.info("创建购买计划:%s",price)
    input = pd.Series(np.logspace(-10, 0, 10, base=1.05)*price)
    tem =  (pd.Series(np.arange(24, 5, -2))*0.01)
    out = (tem +1)*input
    global plandf
    plandf = pd.DataFrame({ "input": input, "out": out, "store":0, "tem":tem})
    logging.info("购买计划创建完毕\n%s",plandf)

def getsellprice():
    # 获取购买价格
    return plandf[plandf.store > 0].out.min()


if __name__ == '__main__':
    makeplan(1)
    price =  getsellprice()
    





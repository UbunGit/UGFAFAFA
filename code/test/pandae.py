import numpy as np
import pandas as pd
import sys
import logging
import os
logging.basicConfig(level=logging.NOTSET)  # 设置日志级别

#样集1
df1=pd.DataFrame({'A':['A0','A1','A2','A3'],'B':['B0','B1','B2','B3'],
                  'C':['C0','C1','C2','C3'],'D':['D0','D1','D2','D3']},
                index=[0,1,2,3])
#样集2
df2=pd.DataFrame({'A':['A4','A5','A6','A7'],'B':['B4','B5','B6','B7'],
                  'C':['C4','C5','C6','C7'],'D':['D4','D5','D6','D7']},
                  index=[0,1,2,9])   
#样集3
df3=pd.DataFrame({'A':['A8','A9','A10','A11'],'B':['B8','B9','B10','B11'],
                  'C':['C8','C9','C10','C11'],'D':['D8','D9','D10','D11']},
                index=[0,1,6,3])   
#样集4
df4=pd.DataFrame({'B':['B2','B3','B6','B7'],'D':['D2','D3','D6','D7'],
                  'F':['F2','F3','F6','F7']},index=[0,1,2,5])
#样集1、2、3、4详见图1.1（a）                                                             
#列名（columns）相同，行索引（index）无重复项的表df1、df2、df3实现行拼接
frames = [df1, df2, df3]
df = pd.concat(frames,axis=1)                


logging.info("\n%s",df)


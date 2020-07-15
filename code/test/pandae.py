import numpy as np
import pandas as pd
import sys
import logging
import os
logging.basicConfig(level=logging.NOTSET)  # 设置日志级别

s = pd.Series(np.logspace(-10, 5, 10, base=0.95)*10)
logging.info(s)

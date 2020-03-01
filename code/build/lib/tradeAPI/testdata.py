import pandas
import sys

import tradeAPI

tcode = sys.argv[1]
amount = sys.argv[2]
start = sys.argv[3]
end = sys.argv[4]
history = pandas.read_csv('/Users/admin/Documents/github/UGFAFAFA/file/000652.csv', parse_dates=True, index_col=0)
print(tcode)
print(amount)
print(start)
print(end)


print(history.to_json(orient='records'))



# import os, sys, subprocess, tempfile, time, json
# import logging
# # python编译器位置
# EXEC = sys.executable

# def decode(s):
#     try:
#         return s.decode('utf-8')
#     except UnicodeDecodeError:
#         return s.decode('gbk')
        
# outdata = decode(subprocess.check_output([EXEC, './testdata.py'  ,'001', '1000' ,'None','None'], stderr=subprocess.STDOUT, timeout=15))
# print(outdata)
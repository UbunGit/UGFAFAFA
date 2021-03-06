#zxby.py
# -*- coding: utf-8 -*-
# __author__="ZJL"
 
import os, sys, subprocess, tempfile, time, json
import logging
# 创建临时文件夹,返回临时文件夹路径
TempFile = tempfile.mkdtemp(suffix='_test', prefix='python_')
# 文件名
FileNum = int(time.time() * 1000)
# python编译器位置
EXEC = sys.executable
 
 
# 获取python版本
def get_version():
    v = sys.version_info
    version = "python %s.%s" % (v.major, v.minor)
    return version
 
 
# 获得py文件名
def get_pyname():
    global FileNum
    return 'test_%d' % FileNum
 
 
# 接收代码写入文件
def write_file(pyname, code):
    fpath = os.path.join(TempFile, '%s.py' % pyname)
    with open(fpath, 'w', encoding='utf-8') as f:
        f.write(code)
    print('file path: %s' % fpath)
    return fpath

# 接收代码写入文件
def getcmd(fpath, tcode = '000100',amount=10000,start = None,end = None):

    return fpath +" "+ str(tcode) +" "+ str(amount) + " "+ str(start)  +" "+ str(end)
 
 
# 编码
def decode(s):
    try:
        return s.decode('utf-8')
    except UnicodeDecodeError:
        return s.decode('gbk')
 
# 主执行函数
def main(code,tcode = '000100',amount=10000,start = None,end = None):

    pyname = get_pyname()
    fpath = write_file(pyname, code)
    outdata = decode(subprocess.check_output([EXEC, fpath, str(tcode), str(amount), str(start),str(end)], stderr=subprocess.STDOUT, timeout=55))
    return json.loads(outdata,strict=False)

 
if __name__ == '__main__':
    code = "print(11);print(22)"
    print(main(code))

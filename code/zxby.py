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
    r = dict()
    r["version"] = get_version()
    pyname = get_pyname()
    fpath = write_file(pyname, code)

    try:
        # subprocess.check_output 是 父进程等待子进程完成，返回子进程向标准输出的输出结果
        # stderr是标准输出的类型

        outdata = decode(subprocess.check_output([EXEC, fpath, str(tcode), str(amount), str(start),str(end)], stderr=subprocess.STDOUT, timeout=15))
    except subprocess.CalledProcessError as e:
        # e.output是错误信息标准输出
        # 错误返回的数据
        r["code"] = 'Error'
        r["data"] = decode(e.output)
        # r["output"] = json.loads(e.output)
        return r
    else:
        # 成功返回的数据
        r['data'] = json.loads(outdata)
        r["code"] = "Success"
        return r
    finally:
        # 删除文件(其实不用删除临时文件会自动删除)
        try:
            os.remove(fpath)
            logging.debug(fpath)
        except Exception as e:
            exit(1)
 
if __name__ == '__main__':
    code = "print(11);print(22)"
    print(main(code))

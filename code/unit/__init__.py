

import hashlib
import os,datetime,time

def get_md5_value_two(str1):
    # 获取字符串md5
    md5 = hashlib.md5()
    md5.update(str1)
    result = md5.hexdigest()
    return result

def isneedupdate(file):
    if os.path.exists(file) == False:
        return True
    pt = os.path.getmtime(file)
    ctime = datetime.datetime.fromtimestamp(pt)
    now = time.localtime(time.time())
          
    if now.tm_hour<=16:
        jtime = datetime.datetime(now.tm_year, now.tm_mon, now.tm_mday-1, 16, 00)
    else:
        jtime = datetime.datetime(now.tm_year, now.tm_mon, now.tm_mday, 16, 00)
    if ctime <= jtime:
        return True
    return False


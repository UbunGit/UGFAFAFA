

import hashlib


def get_md5_value_two(str1):
    # 获取字符串md5
    md5 = hashlib.md5()
    md5.update(str1)
    result = md5.hexdigest()
    return result

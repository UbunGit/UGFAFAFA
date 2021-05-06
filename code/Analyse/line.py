# 获取
def lineType(line1 = [],line2 = []):
    # 上平行
    if (line1[0] > line2[0]) and (line1[1] > line2[1]) :
        return 0
    
     # 下平行
    if (line1[0] < line2[0]) and (line1[1] < line2[1]) :
        return 1
    
    # 下相交
    if (line1[0] >= line2[0]) and (line1[1] < line2[1]):
        return 2
    
    # 上相交
    if (line1[0] <= line2[0]) and (line1[1] > line2[1]):
        return 3
    
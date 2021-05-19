def bcomm(amount):
    '''
    买入手续费
    ''' 
    yongjin = 5 if amount*0.003<5 else amount*0.003
    yinhua = 0
    guohu = amount*0.0006
    return yongjin+yinhua+guohu

def scomm(amount):
    '''
    计算买入手续费
    ''' 
    yongjin = 5 if amount*0.003<5 else amount*0.003
    yinhua =  amount*0.001
    return yongjin+yinhua
    return 0
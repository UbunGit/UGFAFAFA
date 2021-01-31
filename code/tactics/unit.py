def buyCount(price, money):
    return int(money/(price*100))*100

class TError(BaseException):
    def __init__(self, arg):
        self.msg = arg
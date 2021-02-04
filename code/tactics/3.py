#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys
import os, json, logging
codepath = os.path.join(os.getcwd(),"code")
sys.path.append(codepath)

from trade import share
from trade import Stores
from .unit import buyCount,TError

stores = None
inScale = 0.95
outScale = 1.20
money = 20000

def setup(param={
            'code': "300022.SZ",
            'begin': '20200107',
            'end': '20210607',
            'money': 20000
            }):
    try:
        print(param)
        global code
        global begin 
        global end
        global money
        global inScale
        global inScale
        global outScale
        global stores
        global acount
        
        money = 20000
        acount = 2000
        code = param.get('code')
        begin = param.get('begin')
        end = param.get('end')

        if param.__contains__("money"):
            money = float(param.get('money'))
        if param.__contains__("acount"):
            acount = float(param.get('acount'))
        
        if param.__contains__("inScale"):
            inScale = float(param.get('inScale'))
        if param.__contains__("outScale"):
            outScale = float(param.get('outScale'))

        stores = Stores(balance = money)
        spd = share(code)
        if spd.cdata is None:
            return []
        data = spd.cdata
        data = spd.appendma(data=data,ma=5)
        data = spd.appendma(data=data,ma=10)
        data = spd.appendma(data=data,ma=20)
        data = spd.appendma(data=data,ma=25)
        data = spd.appendma(data=data,ma=30)
        data['yclose']= data["close"].shift(1)
        data['yopen']= data["open"].shift(1)
        data['yma5']= data["ma5"].shift(1)
        data['yma20']= data["ma20"].shift(1)
        data['yma10']= data["ma10"].shift(1)
        data['yma25']= data["ma25"].shift(1)
        data['yma30']= data["ma30"].shift(1)
        print(data)
        if begin != None:
            data = data[data.date>=begin]
        if end != None:
            data = data[data.date<=end]

        shares = json.loads(data.to_json(orient='records'))

        logging.info(
            '''
            02 -setup
            余额：{}
            持仓：{}
            持仓记录：{}
            代码：{}
            ''' .format(
                stores.balance,
                stores.assets,
                stores.online,
                code
            )
        )
        return shares
    except Exception as e:
            logging.warning("real error%s",e)


def buy(share):
    try:
     
        if share.get('yma20') > share.get('yma30') or share.get('ma20') < share.get('ma30'):
            raise TError('''均线没有相交yma20:{} ma30:{} ma20:{} yma30:{}'''.format(
        share.get('yma20'),
        share.get('ma30'),
        share.get('ma20'),
        share.get('yma30'),
        ))

        price = share.get("close")

        if len(stores.online)>0:
            scalePrice = stores.minPrice()*inScale
            price = min([scalePrice,price])
        if price<share.get('close'):
            raise TError('''买入价{:.3f}小于收盘价{:.3f}'''.format(price,share.get('close')))


        bcount = buyCount(price, acount)
        totalPrice =  price*bcount
        if stores.balance < totalPrice:
            raise TError('''余额不足!!!''')
        store = {
            "num":bcount,
            "bdate":share.get("date"),
            "bprice":price,
            "inday":0
        }
        stores.buy(store)

    except TError as err:
        share["B"]={
            "isBuy":False,
            "msg":err.msg
        }

    except Exception as e:
        share["B"]={
            "isBuy":False,
            "msg":"Exception"
        }   
    else:

        share["B"]={
            "isBuy":True,
            "data":store
        }
       
        
    finally:
        logging.info("{}/n\n".format(share["B"]))
        return share

def seller(share):
    try:
        if len(stores.online) == 0:
            raise TError('''持仓为空''')
        # if share.get('ma5')>share.get('ma10'):
        #     raise TError('''ma10 {:.3f}小于ma5 {:.3f}'''.format(share.get('ma10'),share.get('ma5')))
        sellers = []

        for item in stores.online:
            item["inday"]= item.get("inday") +1
            sellerPrice = item.get("bprice") * outScale
      
            if sellerPrice < share.get('high'):
                item["sdate"] = share.get("date")
                item["sprice"] = max([sellerPrice,share.get('close')])
                item["isSeller"] = True
                item["fee"] = 10.00
                stores.seller(item)
                sellers.append(item)
        if len(sellers)==0:
            raise TError('''没有符合条件的卖出单''')

    except TError as err:
        share["S"]={
            "isSeller":False,
            "msg":err.msg
        }
  
    else:
        
        share["S"]={
            "isSeller":True,
            "data":sellers
        }
        
    finally:
        return share

def summary(share):
    share["blance"]= stores.balance
    share["assets"] = stores.assets
    share["summary"] = (stores.assets*share.get("close")) + stores.balance
    share["online"]= stores.online
    share["money"]= money
    return share

def finesh():
    return {
       "line":stores.line 
    }

if __name__ == '__main__':
    
    shares = setup({'code': '300022.sz', 'begin': '20200107', 'end': '20210101', 'money': '20000', 'inScale': '0.95', 'outScale': '1.10', 'acount': '2000'})
    for item in shares:
        data = seller(item)
        data = buy(data)
        data = summary(data)
        print(data)

    print(stores.line)

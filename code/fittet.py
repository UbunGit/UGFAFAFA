from trade import trade

cent = trade('000100', begin=None, end= None, balance=1000)


isscre, msg = cent.buy(2.50, '2020-10-11', count=100)
isscre, msg = cent.sell(3.50, '2020-10-12', count=100)

print(str(isscre),str(msg))
print(cent.balance)
print(cent.data.to_json(orient='records'))
## 查询
pd.loc

## 删除表中全部为NaN的行
df.dropna(axis=0,how='all') 

## 删除表中含有任何NaN的行
df.dropna(axis=0,how='any') #drop all rows that have any NaN values

## 删除表中全部为NaN的列
df.dropna(axis=1,how='all') 

## 删除表中含有任何NaN的列
df.dropna(axis=1,how='any') #drop all rows that have any NaN values
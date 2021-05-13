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


# 分组

series：需要分组的数据
bins：分组的划分数组
right：分组的时候，右边是否闭合
labels：分组的自定义标签，可以不自定义

```
df=read_csv(r"C:\Users\JackPi\Desktop\pandas\data\data14.csv",sep="|")
 
bins=[min(df.cost)-1,20,40,60,80,100,max(df.cost)+1]
 
labels=['20以下','20到40','40到60','60到80','80到100','100以上']
 
result=pandas.cut(df.cost,bins=bins,right=False,labels=labels)
```

# 总结数据信息
```
#数据之和df.sum()
#数据中的最小值df.min()
#数据中的最大值df.max()
#最小值的索引df.idxmin()
#最大值的索引df.idxmax()
#数据统计信息，有四分位数，中位数等df.describe()
#平均值df.mean()
#中位数值df.median() 
```
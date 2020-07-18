import pandas, numpy
history = pandas.read_csv('/Users/mba/share/tem/tem.csv') 
print(history.to_json(orient='records'))
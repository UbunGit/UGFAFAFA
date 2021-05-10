import pandas as pd
from pyecharts.charts import Kline
from pyecharts.charts import Line, Bar, Grid, Pie,Scatter
from pyecharts import options as opts
from pyecharts.commons.utils import JsCode

def pie(data,name = "pie", width = "100%",height="300px"):
    print(data)
    pie = Pie(init_opts=opts.InitOpts(width=width ,height=height))
    pie.add(
            "b",
            [list(z) for z in zip(data.index, data.values)],
            radius="40%",
            center=["50%", "50%"],
    )
    pie.set_global_opts(
            title_opts=opts.TitleOpts(title="收益", pos_top="0"),
            legend_opts=opts.LegendOpts(pos_top="0"),
    )
   
    return pie
 

if __name__ == '__main__':
    data = pd.read_csv("/Users/admin/Documents/GitHub/UGFAFAFA/data/output/damrey/000001.SZ/result.csv",dtype={"sdate":"string"})
    bardata = data[data["earnings"].notnull() == True]
    earnings = (bardata["smoney"]*10/bardata["bmoney"]).astype('int').value_counts(
            normalize=True, ascending=True)
    print(pie(earnings).render("/Users/admin/Documents/github/UGFAFAFA/data/tem/result.html"))


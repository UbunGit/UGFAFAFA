import pandas as pd
from pyecharts.charts import Kline
from pyecharts.charts import Line, Bar, Grid, Pie,Scatter
from pyecharts import options as opts
from pyecharts.commons.utils import JsCode

def pie(data,name = "pie", width = "100%",height="300px"):

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
 
def bar(data,name = "bar", width = "100%",height="300px"):

    bar = Bar(init_opts=opts.InitOpts(width=width ,height=height))
    bar.add_xaxis(["{}".format(i) for i in data.index])
    bar.add_yaxis(
        "收益率占比",
        [i for i in data.values.round(decimals=2)],
    )
    return bar




if __name__ == '__main__':
    data = pd.read_csv("/Users/admin/Documents/GitHub/UGFAFAFA/data/output/damrey/000001.SZ/result.csv",dtype={"sdate":"string"})
    bardata = data[data["earnings"].notnull() == True]
    earnings = (bardata["smoney"]/bardata["bmoney"]).round(decimals=2).value_counts(
            normalize=True, ascending=True)
    data = earnings.sort_index()

    group = bar(data).overlap(pie(data))
    
    print(group.render("/Users/admin/Documents/github/UGFAFAFA/data/tem/result.html"))


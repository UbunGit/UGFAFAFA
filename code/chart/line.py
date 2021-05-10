import pandas as pd
from pyecharts.charts import Kline
from pyecharts.charts import Line, Bar, Grid, Pie,Scatter
from pyecharts import options as opts
from pyecharts.commons.utils import JsCode

def line(data,name = "line", width = "100%",height="300px",index="date"):

    xaxis = data["date"].astype('str').values.tolist()

    line = Line(init_opts=opts.InitOpts(width=width ,height=height))
    line.add_xaxis(xaxis)
    for item in data.columns.values.tolist():
        if item == index : continue
        line.add_yaxis(
            series_name=item,
            y_axis=data[item].values.tolist(),
            is_smooth=True,
            is_hover_animation=False,
            linestyle_opts=opts.LineStyleOpts(width=3, opacity=0.5),
            label_opts=opts.LabelOpts(is_show=False),
        )
    return (
        line.set_global_opts(
            legend_opts=opts.LegendOpts(pos_top="0%"),
            title_opts=opts.TitleOpts(
                title="bandans",
                pos_top="0%"
            )
        )
    )
 

if __name__ == '__main__':
    df = pd.read_csv("/Users/admin/Documents/GitHub/UGFAFAFA/data/output/damrey/000001.SZ/result.csv",dtype={"sdate":"string"})
 

    data = pd.DataFrame()
    data["date"] = df["date"]
    data["closev"] = df["close"]/(df["close"].iloc[1])
    data["assetsv"] = df["assets"]/10000
    data.to_csv("/Users/admin/Documents/github/UGFAFAFA/data/tem/test.csv")        
    print(data)
    print(line(data).render("/Users/admin/Documents/github/UGFAFAFA/data/tem/result.html"))
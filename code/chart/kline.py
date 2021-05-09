
import pandas as pd
from pyecharts.charts import Kline
from pyecharts.charts import Line, Bar, Grid, Pie,Scatter
from pyecharts import options as opts
from pyecharts.commons.utils import JsCode

def kline(data, title = "K线图"):
        
        xaxis = data["date"].astype('str').values.tolist()
        yaxis = data[["open", "close", "high",
                                "low"]].values.tolist()
        
        chart = Kline(init_opts=opts.InitOpts(width="100%", height="300px"))
        chart.add_xaxis(xaxis)
        chart.add_yaxis(
            "kline",
            yaxis,
            itemstyle_opts=opts.ItemStyleOpts(
                color="#ec0000",
                color0="#00da3c",
                border_color="#8A0000",
                border_color0="#008F28",
            ),
        )
        chart.set_global_opts(
            
            xaxis_opts=opts.AxisOpts(is_scale=True),
            yaxis_opts=opts.AxisOpts(
                is_scale=True,
                splitarea_opts=opts.SplitAreaOpts(
                    is_show=True, areastyle_opts=opts.AreaStyleOpts(opacity=1)
                ),
            ),
            datazoom_opts=[opts.DataZoomOpts(
                pos_bottom="0px",
                range_start= 100.00-(5000.00/len(xaxis)),
                range_end= 100.00,
                )],
            title_opts=opts.TitleOpts(title=title),
        )
        return chart

if __name__ == '__main__':
    data = pd.read_csv("/Users/admin/Documents/GitHub/UGFAFAFA/data/output/damrey/000001.SZ/result.csv")
    print(kline(data).render("/Users/admin/Documents/github/UGFAFAFA/data/tem/result.html"))

import pandas as pd
from pyecharts.charts import Kline
from pyecharts.charts import Line, Bar, Grid, Pie,Scatter
from pyecharts import options as opts
from pyecharts.commons.utils import JsCode
import logging
bsArea = []

def bspoint(data):
    bspoints = []
    global bsArea 
    bsArea = []
    def bs(data):
        if data["count"] > 0:
            bspoints.append(
                opts.MarkPointItem(
                    name="B",
                    coord = [str(data["date"]), data["bprice"]],
                    symbol_size = 12,
                    itemstyle_opts = opts.ItemStyleOpts(color="#ec0000"),
                )
            )
            # print("bspoints and b "+str(data["date"])+" / "+str(data["bprice"]))
            bspoints.append(
                opts.MarkPointItem(
                    name="S",
                    coord = [str(int(data["sdate"])), data["sprice"]],
                    symbol_size = 12,
                    value = str(round(data["earnings"],2)),
                    itemstyle_opts = opts.ItemStyleOpts(
                        color="#00da3c" if data["earnings"]>0 else "#f47920",
                        area_color="#00da3c" if data["earnings"]>0 else "#f47920"
                    ),
                )
            )
            # print("bspoints and s "+str(int(data["sdate"]))+" / "+str(data["sprice"]))
            bsArea.append(
                opts.MarkAreaItem(
                    x=(str(data["date"]), str(int(data["sdate"]))),
                    itemstyle_opts = opts.ItemStyleOpts(
                        color="#ec0000" if data["earnings"]>0 else "#00da3c",
                        opacity=0.1
                    ),
                )
            )
            # print("bspoints and Area "+str(data["date"])+" / "+str(int(data["sdate"])))

    data.apply(bs,axis=1)
    return bspoints


def maline(data,mas=[5,10,20,30]):
    if data.empty:
        return Line()
    line = Line()
    line.add_xaxis(data["date"].astype('str').values.tolist())
    for item in mas:
        key = "ma"+str(item)
        if key not in data.columns.values.tolist():
            continue
        line.add_yaxis(
            series_name="ma"+str(item),
            y_axis=data["ma"+str(item)],
            is_smooth=True,
            is_hover_animation=False,
            linestyle_opts=opts.LineStyleOpts(width=3, opacity=0.5),
            label_opts=opts.LabelOpts(is_show=False),
        )
    return line

def kline(data, title = "K线图", height = "250px"):

    logging.debug("kline begin")
    # logging.debug(data)
    if data.empty:
        return Kline(init_opts=opts.InitOpts(width="100%", height= height))

    xaxis = data["date"].astype('str').values.tolist()
    yaxis = data[["open", "close", "high",
                                "low"]].values.tolist()
        
    chart = Kline(init_opts=opts.InitOpts(width="100%", height= height))
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
        markline_opts=opts.MarkLineOpts(
            data=[opts.MarkLineItem(type_="max", value_dim="close")]
        ),
        markpoint_opts=opts.MarkPointOpts(
            data=bspoint(data)
        ),
    )
    chart = chart.overlap(maline(data))
       
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
    chart.set_series_opts(
        markarea_opts=opts.MarkAreaOpts(
            data=bsArea
        )
    )
    return chart


if __name__ == '__main__':
    import sys
    sys.path.append('/Users/admin/Documents/GitHub/UGFAFAFA/code')
    from Analyse.back_trading import back_trading
    df = pd.read_csv("/Users/admin/Documents/GitHub/UGFAFAFA/data/output/damrey/002028.SZ/result.csv")
    df = back_trading(df, begin=20200513,end=20210513,signal="signal")
    print(kline(df).render("/Users/admin/Documents/github/UGFAFAFA/data/tem/result.html"))

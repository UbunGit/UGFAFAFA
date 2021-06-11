#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from pyecharts import options as opts
from pyecharts.charts import Bar, Grid,Kline, Line, Liquid, Page, Pie
from pyecharts.commons.utils import JsCode
from pyecharts.components import Table
from pyecharts.faker import Faker
import pandas as pd

  
def buypoint(data):
    coord = [data.name.strftime("%Y-%m-%d"),data["price"]]

    return opts.MarkPointItem(
        name="B",
        coord = coord,
        symbol_size = 12,
        value = str(round(data["price"],2)),
        itemstyle_opts = opts.ItemStyleOpts(color="#ec0000"),
    )
def sellpoint(data):
    coord = [data.name.strftime("%Y-%m-%d"),data["price"]]
    return opts.MarkPointItem(
        name="S",
        coord = coord,
        symbol_size = 12,
        value = str(round(data["price"],2)),
        itemstyle_opts = opts.ItemStyleOpts(color="#00da3c"),
    )
def bszone(data):
    
    return opts.MarkAreaItem(
        x=(data["begin"].strftime("%Y-%m-%d"), data["end"].strftime("%Y-%m-%d")),
        itemstyle_opts = opts.ItemStyleOpts(
            color="#ec0000" if data["earnings_v"]>0 else "#00da3c",
            opacity=0.1
        ),
    )

def kline(
    data,
    buy = [],
    sell = [],
    zone =[],
    title = "K线图",
    height = "250px"
  ):
    if data.empty:
        return Kline(init_opts=opts.InitOpts(width="100%", height= height))

    xaxis = pd.Series(data.index).apply(lambda x: x.strftime("%Y-%m-%d")).to_list()
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
        # markline_opts=opts.MarkLineOpts(
        #     data=[opts.MarkLineItem(type_="max", value_dim="close")]
        # ),
        markpoint_opts=opts.MarkPointOpts(
            data = buy.apply(buypoint,axis=1).values.tolist()+(sell.apply(sellpoint,axis=1).values.tolist())
        ),
    )
    chart.set_series_opts(
        markarea_opts=opts.MarkAreaOpts(
            data=zone.apply(bszone,axis=1).values.tolist()
        )
    )
    # chart = chart.overlap(maline(data))
       
    # chart.set_global_opts(
    #     xaxis_opts=opts.AxisOpts(is_scale=True),
    #     yaxis_opts=opts.AxisOpts(
    #         is_scale=True,
    #         splitarea_opts=opts.SplitAreaOpts(
    #             is_show=True, areastyle_opts=opts.AreaStyleOpts(opacity=1)
    #         ),
    #     ),
    #     datazoom_opts=[opts.DataZoomOpts(
    #         pos_bottom="0px",
    #         range_start= 100.00-(5000.00/len(xaxis)),
    #         range_end= 100.00,
    #         )],
    #         title_opts=opts.TitleOpts(title=title),
    # )
  
    return chart


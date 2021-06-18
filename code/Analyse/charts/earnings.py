#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from pyecharts import options as opts
from pyecharts.charts import Bar, Grid,Kline, Line, Liquid, Page, Pie
from pyecharts.commons.utils import JsCode
from pyecharts.components import Table
from pyecharts.faker import Faker
import pandas as pd

def earningsLine(data,keys,name="收益对比曲线图"):
    if data.empty or keys==None or len(keys)==0:
        return Line()
    line = Line()
    xaxis = pd.Series(data.index).apply(lambda x: x.strftime("%Y-%m-%d")).to_list()
    line.add_xaxis(xaxis)
    for item in keys:
        line.add_yaxis(
            series_name=item,
            y_axis=data[item].round(decimals=2),
            is_smooth=True,
            is_hover_animation=False,
            linestyle_opts=opts.LineStyleOpts(width=3, opacity=0.5),
            label_opts=opts.LabelOpts(is_show=False),
        )
    return line

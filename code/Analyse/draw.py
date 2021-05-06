#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import pandas as pd
from pyecharts.charts import Kline
from pyecharts.charts import Line, Bar, Grid,Pie
from pyecharts import options as opts
from pyecharts.commons.utils import JsCode
import datetime

class draw:

    file = None
    data = None
    savefile = "/Users/admin/Documents/github/UGFAFAFA/data/tem"
    xaxis = []
    yaxis = []
    vols = []

    begin = (datetime.datetime.now()+datetime.timedelta(days=-100)).strftime('%Y%m%d')
    end = (datetime.datetime.now()).strftime('%Y%m%d')

    def __init__(self,file):
        print(self.begin)
        self.file = file
        self.data = pd.read_csv(file).sort_values(by='date')
       
        # self.data = self.data[(self.data["date"] > int(self.begin)) & (self.data["date"] < int(self.end))]

    def get_baseData(self):

        self.xaxis = self.data["date"].astype('str').values.tolist()
        self.yaxis = self.data[["open","close","high","low"]].values.tolist()
        self.vols =  self.data["vol"].values.tolist()
        print(self.vols)
        print(type(self.vols))

    def calculate_ma(self, day_count: int):
        result = self.data["ma"+str(day_count)].values.tolist()
        print(result)
        print(type(result))
        return result
        

    def draw(self):
        self.get_baseData()

        kline = (
        
            Kline()
            .add_xaxis(self.xaxis)
            .add_yaxis(
                "kline",
                self.yaxis,
                itemstyle_opts=opts.ItemStyleOpts(
                    color="#ec0000",
                    color0="#00da3c",
                    border_color="#8A0000",
                    border_color0="#008F28",
                ),
            )
            .set_global_opts(
                xaxis_opts=opts.AxisOpts(is_scale=True),
                yaxis_opts=opts.AxisOpts(
                    is_scale=True,
                    splitarea_opts=opts.SplitAreaOpts(
                        is_show=True, areastyle_opts=opts.AreaStyleOpts(opacity=1)
                    ),
                ),
                datazoom_opts=[opts.DataZoomOpts(type_="inside")],
                title_opts=opts.TitleOpts(title="MA均线交易"),
            )
        )
       
        # 均线
        line = (
            Line()
                .add_xaxis(self.xaxis)
                .add_yaxis(
                    series_name="MA5",
                    y_axis=self.calculate_ma(day_count=5),
                    is_smooth=True,
                    is_hover_animation=False,
                    linestyle_opts=opts.LineStyleOpts(width=3, opacity=0.5),
                    label_opts=opts.LabelOpts(is_show=False),
                )
              
                .add_yaxis(
                    series_name="MA30",
                    y_axis=self.calculate_ma(day_count=30),
                    is_smooth=True,
                    is_hover_animation=False,
                    linestyle_opts=opts.LineStyleOpts(width=3, opacity=0.5),
                    label_opts=opts.LabelOpts(is_show=False),
                )
                .set_global_opts(title_opts=opts.TitleOpts(title="Grid-Bar"))
        )
        bardata = self.data[self.data["select"] == False]
        bardata = bardata["close"+"20"+"v"].astype('int').value_counts(normalize = True ,ascending=True)
        pie = (
            Pie()
            .add(
                "b",
                [list(z) for z in zip(bardata.index, bardata.values)],
                radius="35%",
                center=["25%", "80%"],
          
              )

              .set_global_opts(
        title_opts=opts.TitleOpts(title="Grid-Line", pos_top="48%"),
        legend_opts=opts.LegendOpts(pos_top="48%"),
    )
        )


        k = kline.overlap(line)  

        grid = (
            Grid(init_opts=opts.InitOpts(height="800px"))
            .add(k, grid_opts=opts.GridOpts(pos_bottom="60%"))
            .add(pie, grid_opts=opts.GridOpts(pos_top="60%"))
            .render(self.savefile+"/result.html")
        )
        # grid_chart.render(self.savefile+"/result.html")


if __name__ == '__main__':
 
    draw = draw("/Users/admin/Documents/github/UGFAFAFA/data/tem/tem.csv")
    draw.draw()
    


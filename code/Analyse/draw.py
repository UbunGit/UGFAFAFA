#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import pandas as pd
from pyecharts.charts import Kline
from pyecharts.charts import Line, Bar, Grid, Pie,Scatter
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

    begin = (datetime.datetime.now() +
             datetime.timedelta(days=-100)).strftime('%Y%m%d')
    end = (datetime.datetime.now()).strftime('%Y%m%d')

    def __init__(self, file):
        print(self.begin)
        self.file = file
        self.data = pd.read_csv(file).sort_values(by='date')

        # self.data = self.data[(self.data["date"] > int(self.begin)) & (self.data["date"] < int(self.end))]

    def get_baseData(self):

        self.xaxis = self.data["date"].astype('str').values.tolist()
        self.yaxis = self.data[["open", "close", "high",
                                "low"]].values.tolist()
        self.vols = self.data["vol"].values.tolist()
        print(self.vols)
        print(type(self.vols))

    def calculate_ma(self, day_count: int):
        result = self.data["ma" + str(day_count)].values.tolist()
        return result
    
    def kline(self):
        xaxis = self.data["date"].astype('str').values.tolist()
        yaxis = self.data[["open", "close", "high",
                                "low"]].values.tolist()
        return (
            Kline()
                .add_xaxis(xaxis)
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
                            is_show=True,
                            areastyle_opts=opts.AreaStyleOpts(opacity=1)),
                    ),
                    datazoom_opts=[opts.DataZoomOpts(type_="inside")],
                    title_opts=opts.TitleOpts(title="MA均线交易"),
                )
            )

    def maline(self,mas):
        xaxis = self.data["date"].astype('str').values.tolist()
        line = Line()
        line.add_xaxis(self.xaxis)
        for item in mas:
            line.add_yaxis(
                series_name="MA"+str(item),
                y_axis=self.calculate_ma(day_count=int(item)),
                is_smooth=True,
                is_hover_animation=False,
                linestyle_opts=opts.LineStyleOpts(width=3, opacity=0.5),
                label_opts=opts.LabelOpts(is_show=False),
            )
        return (
            line.set_global_opts(title_opts=opts.TitleOpts(title="Grid-Bar"))\
            )

    def pie(self):
        bardata = self.data[self.data["select"] == True]
        bardata = bardata["close" + "5" + "v"].astype('int').value_counts(
            normalize=True, ascending=True)
        return (
            Pie()
            .add(
                "b",
                [list(z) for z in zip(bardata.index, bardata.values)],
                radius="35%",
                center=["25%", "80%"],
            )
            .set_global_opts(
                title_opts=opts.TitleOpts(title="Grid-Line", pos_top="48%"),
                legend_opts=opts.LegendOpts(pos_top="48%"
            ),
        ))

    def point(self):
        pointdata = self.data[self.data["select"] == True]
        xaxis = pointdata["date"].astype('str').values.tolist()
        yaxis = pointdata["close"].values.tolist()
        return(
            Scatter()
            .add_xaxis(xaxis_data=xaxis)
            .add_yaxis(
                series_name="",
                y_axis=yaxis,
                symbol_size=20,
                label_opts=opts.LabelOpts(is_show=False),
            )
        )
    def draw(self):
        self.get_baseData()

        kline = self.kline()
        # 均线
        line = self.maline([5,30])

        pie = self.pie()
        point = self.point()

        k = kline.overlap(line)
        k = k.overlap(point)

        grid = (Grid(init_opts=opts.InitOpts(height="800px")).add(
            k, grid_opts=opts.GridOpts(pos_bottom="60%")).add(
                pie,
                grid_opts=opts.GridOpts(pos_top="60%")).render(self.savefile +
                                                               "/result.html"))



if __name__ == '__main__':

    draw = draw("/Users/admin/Documents/github/UGFAFAFA/data/tem/tem.csv")
    draw.draw()

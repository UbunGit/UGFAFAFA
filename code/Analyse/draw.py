#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
sys.path.append("/Users/admin/Documents/github/UGFAFAFA/code/")

import datetime
import pandas as pd
from pyecharts.charts import Kline
from pyecharts.charts import Line, Bar, Grid, Pie,Scatter
from pyecharts import options as opts
from pyecharts.commons.utils import JsCode
from config import dataPath as root
from file import mkdir
from Tusharedata import lib, loadDaily



class draw:
    title = "fenxi"
    code = ""
    signal = "signal"
    ma = [5,10,20,30]
    data = None

    savefile = root
    begin = (datetime.datetime.now() +
             datetime.timedelta(days=-100)).strftime('%Y%m%d')
    end = (datetime.datetime.now()).strftime('%Y%m%d')

    def __init__(self, data):
        self.data = data

    def kline(self):
        klinedata = self.data
        xaxis = klinedata["date"].astype('str').values.tolist()
        yaxis = klinedata[["open", "close", "high",
                                "low"]].values.tolist()
        return (
            Kline()
                .add_xaxis(xaxis)
                .add_yaxis(
                    "kline",
                    yaxis,
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
                            areastyle_opts=opts.AreaStyleOpts(
                                opacity=1,
                                
                            )
                        ),
                            
                    )
                  
                        
                )
                .set_global_opts(
                    xaxis_opts=opts.AxisOpts(is_scale=True),
                    yaxis_opts=opts.AxisOpts(
                        is_scale=True,
                        splitarea_opts=opts.SplitAreaOpts(
                            is_show=True, areastyle_opts=opts.AreaStyleOpts(opacity=1)
                        ),
                    ),
                    datazoom_opts=[opts.DataZoomOpts(
                        pos_top="350px",
                   
                        range_start= 100.00-(5000.00/len(xaxis)),
                        range_end= 100.00,
                        )],
                    title_opts=opts.TitleOpts(title="MA均线交易"),
                )
        )

    def maline(self):
        malinedata = self.data
        xaxis = malinedata["date"].astype('str').values.tolist()
        line = Line()
        line.add_xaxis(xaxis)
        for item in self.ma:
            line.add_yaxis(
                series_name="ma"+str(item),
                y_axis=malinedata["ma"+str(item)],
                is_smooth=True,
                is_hover_animation=False,
                linestyle_opts=opts.LineStyleOpts(width=3, opacity=0.5),
                label_opts=opts.LabelOpts(is_show=False),
            )
        return (
            line.set_global_opts(title_opts=opts.TitleOpts(title="Grid-Bar"))
        )

    def pie(self):
       
        bardata = self.data.dropna(axis=0, how="any")[self.data["count"] >0.8]
        bardata = bardata["close" + "5" + "v"].astype('int').value_counts(
            normalize=True, ascending=True)
        return (
            Pie()
            .add(
                "b",
                [list(z) for z in zip(bardata.index, bardata.values)],
                radius="80px",
                center=["25%", "950px"],
            )
            .set_global_opts(
                title_opts=opts.TitleOpts(title="Pie", pos_top="820px"),
                legend_opts=opts.LegendOpts(pos_top="820px"),
                )
            )

    def point(self):
        pointdata = self.data
        print(pointdata)
        pointdata = pointdata[pointdata["count"] >0.8]
        xaxis = pointdata["date"].astype('str').values.tolist()
        yaxis = pointdata["close"].values.tolist()
        
        scatter = Scatter()
        scatter.add_xaxis(xaxis_data=xaxis)
        scatter.add_yaxis(
                series_name="B",
                y_axis=yaxis,
                symbol_size=14,
                itemstyle_opts=opts.ItemStyleOpts(
                    color="#ef232a",
                ),      
        )
        scatter.set_global_opts(
          
            title_opts=opts.TitleOpts(title="Scatter-VisualMap(Size)"),
            visualmap_opts=opts.VisualMapOpts(max_=150),
           
        )

        return (scatter)
    
    def cline(self,clume):
        clinedata = self.data[self.data["bandans"] >= 0]
        xaxis = clinedata["date"].astype('str').values.tolist()
    
        line = Line()
        line.add_xaxis(xaxis)
        for item in clume:
            line.add_yaxis(
                series_name=item,
                y_axis=clinedata[item].values.tolist(),
                is_smooth=True,
                is_hover_animation=False,
                linestyle_opts=opts.LineStyleOpts(width=3, opacity=0.5),
                label_opts=opts.LabelOpts(is_show=False),
            )
        return (
            line.set_global_opts(
                legend_opts=opts.LegendOpts(pos_top="420px"),
                title_opts=opts.TitleOpts(
                    title="bandans",
                    pos_top="420px"
                )
            )
        )
    def draw(self,signal = "signal"):
        self.signal = signal
      
        for item in self.ma:
            lib.ma(self.data, item)

        kline = self.kline()
        kline = kline.overlap(self.maline())
        kline = kline.overlap(self.point())
        # kline = kline.overlap(self.cline("bandans"))

        grid = (Grid(init_opts=opts.InitOpts(height="1200px"))
        .add(
            kline,
            grid_opts=opts.GridOpts(pos_top="0px",height="380px")
        )
        
        .add(
            self.cline(["bandans","close"]),
            grid_opts=opts.GridOpts(pos_top="420px",height="360px")
        )
        .add(
            self.pie(),
            grid_opts=opts.GridOpts(pos_top="800px",height="380px")
        )
        .render(self.savefile +"/result.html"))



if __name__ == '__main__':
    data = pd.read_csv("/Users/admin/Documents/GitHub/UGFAFAFA/data/output/damrey/000001.SZ/result.csv")
    print(data)
    draw = draw(data)
    draw.draw()

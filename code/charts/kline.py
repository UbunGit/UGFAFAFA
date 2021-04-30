#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import pandas as pd
from pyecharts.charts import Kline
from pyecharts.charts import Line, Bar, Grid
from pyecharts import options as opts
from pyecharts.commons.utils import JsCode
import datetime

class MAKline:

    file = None
    data = None
    xaxis = []
    yaxis = []
    vols = []

    begin = (datetime.datetime.now()+datetime.timedelta(days=-30)).strftime('%Y%m%d')
    end = (datetime.datetime.now()).strftime('%Y%m%d')

    def __init__(self,file):
        print(self.begin)
        self.file = file
        self.data = pd.read_csv(file).sort_values(by='date')
        self.data = self.data[(self.data["date"] > int(self.begin)) & (self.data["date"] < int(self.end))]
  
  

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
                title_opts=opts.TitleOpts(title="Kline-ItemStyle"),
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
                .set_global_opts(xaxis_opts=opts.AxisOpts(type_="category"))
        )
        overlap_kline_line = kline.overlap(line)  
        grid_chart = Grid(init_opts=opts.InitOpts(width="1400px", height="800px"))
        grid_chart.add(
            overlap_kline_line,
            grid_opts=opts.GridOpts(pos_left="10%", pos_right="8%", height="50%"),
        )
        grid_chart.render("./data/kline_itemstyle.html")

class people:
    #定义基本属性
    name = ''
    age = 0
    #定义私有属性,私有属性在类外部无法直接进行访问
    __weight = 0
    #定义构造方法
    def __init__(self,n,a,w):
        self.name = n
        self.age = a
        self.__weight = w
    def speak(self):
        print("%s 说: 我 %d 岁。" %(self.name,self.age))
 




if __name__ == '__main__':
 
    kline = MAKline("/Users/admin/Documents/github/UGFAFAFA/data/analyse/base.csv")
    kline.draw()
    


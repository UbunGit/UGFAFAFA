#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from pyecharts import options as opts
from pyecharts.charts import Bar, Grid, Kline, Line, Liquid, Page, Pie
import pandas as pd


def buypoint(
    data, 
    date=None,
    price="bprice", 
    value = "signal"
    ):
    '''
    买点
    data 买点的数据 type:{}
    date 时间 None 取data.name,其余取取data[date]
    ...
    ''' 
    coord = [data.name.strftime("%Y-%m-%d") if date == None else data[date].strftime("%Y-%m-%d"),data[price]]

    return opts.MarkPointItem(
        name="B",
        coord = coord,
        symbol_size = 12,
        value = str(round(data[value],2)),
        itemstyle_opts = opts.ItemStyleOpts(color="#ec0000"),
    )

def sellpoint(
    data, 
    date=None,
    price="sprice", 
    value = "signal"
    ):
    '''
    # 卖点
    '''
    coord = [data.name.strftime("%Y-%m-%d") if date == None else data[date].strftime("%Y-%m-%d"),data[price]]
    return opts.MarkPointItem(
        name="S",
        coord = coord,
        symbol_size = 12,
        value = str(round(data[value],2)),
        itemstyle_opts = opts.ItemStyleOpts(color="#00da3c"),
    )

def bsopts(
    blist=None,
    slist=None
    ):
    bslist = []
    if type(blist) == pd.DataFrame:
        bslist = bslist + (blist.apply(buypoint, axis=1).values.tolist())
    if type(slist) == pd.DataFrame:
        bslist = bslist + (slist.apply(sellpoint, axis=1).values.tolist())
    
    return opts.MarkPointOpts(
            data= bslist,
            label_opts=opts.LabelOpts(position="top",
            color="#000",
            font_size = 8,
        ),
    )

def positionsitem(data,begin="bdate",end="sdate",value="assetsv"):
    return opts.MarkAreaItem(
        x=(data[begin], data[end]),
        itemstyle_opts = opts.ItemStyleOpts(
            color="#ec0000" if data[value]>0 else "#00da3c",
            opacity=0.1
        ),
    )
def positionsArea(list):
    # 持仓范围
    return opts.MarkAreaOpts(
        data=list.apply(positionsitem, axis=1).values.tolist()
    )


class BSKline():

    def __init__(self):
        pass

        # K线
    def kline(
        self,
        data,
        title = "K线图",
        open = "open",
        close = "close",
        high = "high",
        low = "low",
        date = None,
        blist = None,
        slist = None,
        positlist = None
        ):
        if type(data) != pd.DataFrame:
            return None

        if data.empty:
            return None
   
        
        
        if date == None:
            xaxis = pd.Series(data.index).apply(lambda x: x.strftime("%Y-%m-%d")).to_list()
        else:
            xaxis = pd.Series(data["date"]).apply(lambda x: x.strftime("%Y-%m-%d")).to_list()

        yaxis = data[[open, close, high, low]].values.tolist()
 
        chart = Kline(init_opts=opts.InitOpts())
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
            markpoint_opts = bsopts(blist=blist,slist=slist)
        )

            

        chart.set_series_opts(
            markarea_opts=opts.MarkAreaOpts(
                data=positionsArea(positlist)
            )
        )
        # chart = maline(data).overlap(chart)
        # chart.set_global_opts(
        #     xaxis_opts=opts.AxisOpts(is_scale=True),
        #     yaxis_opts=opts.AxisOpts(
        #         is_scale=True,
        #         splitarea_opts=opts.SplitAreaOpts(
        #             is_show=True, areastyle_opts=opts.AreaStyleOpts(opacity=1)
        #         ),
        #     ),
        #     # datazoom_opts=datazoom,
        #     title_opts=opts.TitleOpts(title=title),
        # )
        return chart

    def drawChart(self,data = None, ma=None,vol=None,blist=None,slist=None,positlist=None):
        koverlap = self.kline(data=data, blist=blist,slist=slist,positlist = positlist)

        datazoom = [opts.DataZoomOpts(
            pos_bottom="0px",
            range_start= 50.0,
            range_end= 100.00,
        )]

        koverlap.set_global_opts(
            xaxis_opts=opts.AxisOpts(is_scale=True),
            yaxis_opts=opts.AxisOpts(
                is_scale=True,
                splitarea_opts=opts.SplitAreaOpts(
                    is_show=True, areastyle_opts=opts.AreaStyleOpts(opacity=1)
                ),
            ),
            datazoom_opts=datazoom,
            title_opts=opts.TitleOpts(title="eeeee"),
        )
           
        grid = Grid(init_opts=opts.InitOpts())
        if koverlap != None:
            grid.add(
                koverlap,
                grid_opts=opts.GridOpts(pos_top="5%"),
            )

        
        return grid


if __name__ == "__main__":
    positions = pd.read_csv("../data/tem/positions.csv")
    result = pd.read_csv("../data/tem/result.csv")
    # result = result[result["date"]>'20200301']
    result.index= pd.to_datetime(result["date"])

    bskline = BSKline()
    bskline.drawChart(
        data = result,
        blist = result[result["bcount"]>0],
        slist = result[result["scount"]>0],
        positlist = positions
    ).render("../data/tem/bskline.html")



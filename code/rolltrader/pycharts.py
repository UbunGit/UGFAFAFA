from pyecharts import options as opts
from pyecharts.charts import Bar, Grid,Kline, Line, Liquid, Page, Pie
from pyecharts.commons.utils import JsCode
from pyecharts.components import Table
from pyecharts.faker import Faker
import pandas as pd

area = None
datazoom = [opts.DataZoomOpts(
            pos_bottom="0px",
            range_start= 50.0,
            range_end= 100.00,
            )]

def bspoint(data):
    
    bspoints = []
    global bsArea 
    bsArea = []
 
    def bs(data):
        if data["bcount"] > 0:
            
            bspoints.append(
                opts.MarkPointItem(
                    name="B",
                    coord = [data.name.strftime("%Y-%m-%d"), data["bprice"]],
                    symbol_size = 20,
                    value = str(round(data["signal"],2)),
                    itemstyle_opts = opts.ItemStyleOpts(
                        color="#ec0000",
                        color0="#ec0000",
                        area_color = "#ec0000",
                        ),
                )
            )
            
        if data["scount"] > 0:
            bspoints.append(
                opts.MarkPointItem(
                    name="S",
                    coord = [data.name.strftime("%Y-%m-%d"), data["sprice"]],
                    symbol_size = 20,
                    value = str(round(data["signal"],2)),
                    itemstyle_opts = opts.ItemStyleOpts(
                        color="#00da3c"
                    ),
                )
            )

        global area 
        if data["position"] >0:
            if area == None:
                area = {}
                area["assets"] = data["assets"]
                area["date"] = data.name.strftime("%Y-%m-%d")
        else:
            if area is not None:
                shouyi = data["assets"]-area["assets"]
                shouyiv = shouyi/area["assets"]
                print(shouyi)
                bsArea.append(
                    opts.MarkAreaItem(
                        '收益：{:.2f} 收益率：{:.2f}'.format(shouyi, shouyiv),
                        x=(area["date"], data.name.strftime("%Y-%m-%d")),
                        itemstyle_opts = opts.ItemStyleOpts(
                            color="#ec0000" if shouyi>0 else "#00da3c",
                            opacity=0.1
                        ),
                    )
                )
                area = None
 
    data.apply(bs,axis=1)
    return bspoints

def maline(data,mas=[5,10,20,30]):
    if data.empty:
        return Line()
    line = Line()
    xaxis = pd.Series(data.index).apply(lambda x: x.strftime("%Y-%m-%d")).to_list()
    line.add_xaxis(xaxis)
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

def someline(data,lines,name="someline"):
    if data.empty or lines==None or len(lines)==0:
        return Line()
    line = Line()
    xaxis = pd.Series(data.index).apply(lambda x: x.strftime("%Y-%m-%d")).to_list()
    line.add_xaxis(xaxis)
    for item in lines:
        line.add_yaxis(
            series_name=item,
            y_axis=data[item].round(decimals=2),
            is_smooth=True,
            is_hover_animation=False,
            linestyle_opts=opts.LineStyleOpts(width=3, opacity=0.5),
            label_opts=opts.LabelOpts(is_show=False),
        )
    line.set_global_opts(
        title_opts=opts.TitleOpts(name),
        tooltip_opts=opts.TooltipOpts(
            trigger="axis",
          
            ),
        toolbox_opts=opts.ToolboxOpts(is_show=True),
        xaxis_opts=opts.AxisOpts(type_="category", boundary_gap=False),
        datazoom_opts=datazoom,
    )
    return line

# 收益率
def line_shouyi(data, name = "收益分布", width = "100%",height="300px"):
    '''
    收益率与股价对比折线图·
    '''

    line = Line(init_opts=opts.InitOpts(width=width ,height=height))

    xaxis = pd.Series(data.index).apply(lambda x: x.strftime("%Y-%m-%d")).to_list()
    line.add_xaxis(xaxis)

    yaxis1 = (data["assets"]/data["assets"].iloc[1]).tolist()
    line.add_yaxis(
        series_name="资产",
        y_axis=[round(i,3) for i in yaxis1],
        is_smooth=True,
        is_hover_animation=False,
        linestyle_opts=opts.LineStyleOpts(width=3, opacity=0.5),
        label_opts=opts.LabelOpts(
            is_show=False,
            formatter="%.3f %{value}"
            ),
      
    )

    yaxis2 = (data["close"]/ data["close"].iloc[1]).tolist()
    line.add_yaxis(
            series_name="股价",
            y_axis=[round(i,3) for i in yaxis2],
            is_smooth=True,
            is_hover_animation=False,
            linestyle_opts=opts.LineStyleOpts(width=3, opacity=0.5),
            label_opts=opts.LabelOpts(is_show=False),
            
            
        )
    line.set_global_opts(
        title_opts=opts.TitleOpts(title="资产对比", subtitle="资产与股票收盘价对比图"),
        tooltip_opts=opts.TooltipOpts(
            trigger="axis",
          
            ),
        toolbox_opts=opts.ToolboxOpts(is_show=True),
        xaxis_opts=opts.AxisOpts(type_="category", boundary_gap=False),
        datazoom_opts=datazoom,
    )

    return line


# K线
def kline(data, title = "K线图", height = "250px"):

    # logging.debug(data)
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
        markline_opts=opts.MarkLineOpts(
            data=[opts.MarkLineItem(type_="max", value_dim="close")]
        ),
        markpoint_opts=opts.MarkPointOpts(
            data=bspoint(data),
            label_opts=opts.LabelOpts(position="top",
             color="#000",
             font_size = 8,
             ),
        ),
    )
    
       

    chart.set_series_opts(
        markarea_opts=opts.MarkAreaOpts(
            data=bsArea
        )
    )
    chart = maline(data).overlap(chart)
    chart.set_global_opts(
        xaxis_opts=opts.AxisOpts(is_scale=True),
        yaxis_opts=opts.AxisOpts(
            is_scale=True,
            splitarea_opts=opts.SplitAreaOpts(
                is_show=True, areastyle_opts=opts.AreaStyleOpts(opacity=1)
            ),
        ),
        datazoom_opts=datazoom,
        title_opts=opts.TitleOpts(title=title),
    )
    return chart



def page(data,name):
    
    # 页面所有图表
    page = Page(layout=Page.DraggablePageLayout)
    page.page_title = name
    page.add(
        
        kline(data=data),
        line_shouyi(data=data) 
    )
    return page
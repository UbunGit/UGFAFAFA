from pyecharts import options as opts
from pyecharts.charts import Bar, Grid, Line, Liquid, Page, Pie
from pyecharts.commons.utils import JsCode
from pyecharts.components import Table
from pyecharts.faker import Faker
import pandas as pd
# 收益率
def line_shouyi(data,name = "收益分布", width = "100%",height="300px"):
    '''
    收益率与股价对比折线图·
    '''

    line = Line(init_opts=opts.InitOpts(width=width ,height=height))

    xaxis = pd.Series(data.index).apply(lambda x: x.strftime("%Y-%m-%d")).to_list()
    line.add_xaxis(xaxis)

    tenms = lambda x: (x["close"]*x["position"])+x["cash"]
    assets = data.apply(tenms, axis= 1)
    yaxis1 = (assets/assets.iloc[1]).tolist()
    line.add_yaxis(
        series_name="资产",
        y_axis=yaxis1,
        is_smooth=True,
        is_hover_animation=False,
        linestyle_opts=opts.LineStyleOpts(width=3, opacity=0.5),
        label_opts=opts.LabelOpts(is_show=False),
    )

    yaxis2 = (data["close"]/ data["close"].iloc[1]).tolist()
    line.add_yaxis(
            series_name="股价",
            y_axis=yaxis2,
            is_smooth=True,
            is_hover_animation=False,
            linestyle_opts=opts.LineStyleOpts(width=3, opacity=0.5),
            label_opts=opts.LabelOpts(is_show=False),
            axislabel_opts=opts.LabelOpts(formatter="{value} °C"),
        )
    line.set_global_opts(
        title_opts=opts.TitleOpts(title="收益比", subtitle="纯属虚构"),
        tooltip_opts=opts.TooltipOpts(trigger="axis"),
        toolbox_opts=opts.ToolboxOpts(is_show=True),
        xaxis_opts=opts.AxisOpts(type_="category", boundary_gap=False),
    )
    
    return line
    
def page(data,name):
    # 页面所有图表
    page = Page(layout=Page.DraggablePageLayout)
    page.add(
        line_shouyi(data=data) 
    )
    return page
//
//  File.swift
//  
//
//  Created by admin on 2021/4/29.
//

import Foundation
import PythonKit
public struct Kline {
 
    var xaxis:[String]
    var y_axis:[PythonObject]
    var points:[[String : PythonObject]]?
    
    func draw() {
      
        let opts = Python.import("pyecharts").options
        let Kline = Python.import("pyecharts.charts").Kline
        let Line = Python.import("pyecharts.charts").Line
    
        
        let manage =  Kline()
            .add_xaxis(xaxis_data:xaxis)
            .add_yaxis(
                series_name:"cc",
                y_axis:y_axis,
                itemstyle_opts:opts.ItemStyleOpts(
                    color:"#ef232a",
                    color0:"#14b143",
                    border_color:"#ef232a",
                    border_color0:"#14b143"
                ),
                markpoint_opts:opts.MarkPointOpts(
                    data:points
                ),
                markline_opts:opts.MarkLineOpts(
                    data:[opts.MarkLineItem(type_:"max", value_dim:"close")]
                )
            )
            .set_global_opts(
                xaxis_opts:opts.AxisOpts(is_scale:true),
                yaxis_opts:opts.AxisOpts(
                    is_scale:true,
                    splitarea_opts:opts.SplitAreaOpts(
                        is_show:true, areastyle_opts:opts.AreaStyleOpts(opacity:1)
                    )
                ),
                datazoom_opts:[opts.DataZoomOpts(type_:"inside")],
                title_opts:opts.TitleOpts(title:"Kline-ItemStyle")
            )
        
        let html = manage.render()
        print(html)
        
    }
    
    
}

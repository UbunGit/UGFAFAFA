//: [Previous](@previous)

import Foundation
import PythonKit

var begin = "begin"
/*:
 # 测试Bar
 */


/*:
 引入Bar
 ```
 from pyecharts import options as opts
 from pyecharts.charts import Bar
 from pyecharts.commons.utils import JsCode
 from pyecharts.globals import ThemeType
 ```
 */

let bar = Python.import("pyecharts.charts").Bar
let opts  = Python.import("pyecharts").options
let jsCode = Python.import("pyecharts.commons.utils")
let themeType = Python.import("pyecharts.globals")

/*:
 准备数据
 ```
 list2 = [
     {"value": 12, "percent": 12 / (12 + 3)},
     {"value": 23, "percent": 23 / (23 + 21)},
     {"value": 33, "percent": 33 / (33 + 5)},
     {"value": 3, "percent": 3 / (3 + 52)},
     {"value": 33, "percent": 33 / (33 + 43)},
 ]

 list3 = [
     {"value": 3, "percent": 3 / (12 + 3)},
     {"value": 21, "percent": 21 / (23 + 21)},
     {"value": 5, "percent": 5 / (33 + 5)},
     {"value": 52, "percent": 52 / (3 + 52)},
     {"value": 43, "percent": 43 / (33 + 43)},
 ]
 ```
 */
let list2 =  [
    ["value": 12, "percent": 12 / (12 + 3)],
    ["value": 23, "percent": 23 / (23 + 21)],
    ["value": 33, "percent": 33 / (33 + 5)],
    ["value": 3, "percent": 3 / (3 + 52)],
    ["value": 33, "percent": 33 / (33 + 43)],
]

let list3 = [
    ["value": 3, "percent": 3 / (12 + 3)],
    ["value": 21, "percent": 21 / (23 + 21)],
    ["value": 5, "percent": 5 / (33 + 5)],
    ["value": 52, "percent": 52 / (3 + 52)],
    ["value": 43, "percent": 43 / (33 + 43)],
]

/*:
 绘制
 ```

     Bar(init_opts=opts.InitOpts(theme=ThemeType.LIGHT))
     .add_xaxis([1, 2, 3, 4, 5])
     .add_yaxis("product1", list2, stack="stack1", category_gap="50%")
     .add_yaxis("product2", list3, stack="stack1", category_gap="50%")
     .set_series_opts(
         label_opts=opts.LabelOpts(
             position="right",
             formatter=JsCode(
                 "function(x){return Number(x.data.percent * 100).toFixed() + '%';}"
             ),
         )
     )
     .render("stack_bar_percent.html")

 ```
 */

//let html = bar(init_opts:opts.InitOpts())
//    .add_xaxis([1, 2, 3, 4, 5])
//    .add_yaxis("product1", list2, stack:"stack1", category_gap:"50%")
//    .add_yaxis("product2", list3, stack:"stack1", category_gap:"50%")
//    .set_series_opts(
//        label_opts:opts.LabelOpts(
//            position:"right"
//        )
//    )



var end = "end"

//: [Next](@next)

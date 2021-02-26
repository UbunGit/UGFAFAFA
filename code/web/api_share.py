from flask import Blueprint
from .unit import *
from flask import request
import pandas
import json, os
share = Blueprint('share', __name__)

@share.route('/test' , methods=["GET", "POST"])
def test():
    return unit.Response_headers(json.dumps({"code": 200,"data":"test"}))

dpath = os.path.join(os.getcwd(),"data","cvs")
@share.route('/simulation' , methods=["GET"])
def simulation():
    try:
        if request.method == 'GET':
            code = request.args.get("code")
            if None is code:
               raise Exception("股票代码不能为空")
            path = os.path.join(dpath,str(code)+'.csv')
            if not os.path.exists(path):
                raise Exception("数据不存在")
            temdata = pandas.read_csv(path ,dtype={"date":"string"}, index_col=0,)
            temdata = temdata.sort_values(by='date')
            result = temdata.to_json(orient='records')
            return Response_headers(json.dumps({"code": 200,"data":result}))
        else:
            raise Exception("请求格式不正确")
    except Exception as e:
        return json.dumps({"code": -1,"data":str(e)})


    
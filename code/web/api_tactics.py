import sys
from flask import Blueprint

import json,os,subprocess,sys
from flask import request
import pandas as pd

sys.path.append("..") 
from models import Tactics
from database import session
# from .unit import *
from .unit import get_post_data

EXEC = sys.executable
tactics = Blueprint('tactics', __name__)

@tactics.route('/list' , methods=["GET"])
def list():
    try:
        if request.method == 'GET':
 
            tactics =  Tactics.query.all()
            list = []
            for data in tactics:
                list.append(unit.to_json(data,data.__class__)) 
            return unit.Response_headers(json.dumps({"code": 200, "data":list}))
    except Exception as e:
        return json.dumps({"code": -1,"data":str(e)})

@tactics.route('/detailed' , methods=["GET"])
def detailed():
    try:
        if request.method == 'GET':
            tacticid = request.args.get("id")
            if None is tacticid:
               raise Exception("策略id不能为空")
            tactics = session.query(Tactics).filter_by(id=tacticid).first()
            dtactics = unit.to_json(tactics,tactics.__class__)
            pwd = os.getcwd()+dtactics["source"]
            f = open(pwd,'rb')
            dtactics["code"] = f.read().decode(encoding='UTF-8',errors='strict')
            f.close()
            return unit.Response_headers(json.dumps({"code": 200, "data":dtactics}))
    except Exception as e:
        return json.dumps({"code": -1,"data":str(e)})


@tactics.route('/add' , methods=["POST"])
def add():
    try:
        if request.method == 'POST':
            postdata = unit.get_post_data(request)
            tactics = Tactics()
            tactics.owner = postdata["owner"]
            tactics.name = postdata["name"]
            if "source" in postdata:
                tactics.source = postdata["source"]
            if "doc" in postdata:
                tactics.doc = postdata["doc"]
     
            session.add(tactics)
            session.commit()
            
            return unit.Response_headers(json.dumps({"code": 200, "data":"ok"}))
    except Exception as e:
        return json.dumps({"code": -1,"data":str(e)})

@tactics.route('/update' , methods=["POST"])
def update():
    try:
        if request.method == 'POST':
            postdata = get_post_data(request)
            if None is postdata["id"]:
                raise Exception("策略id不能为空") 
            tactics = session.query(Tactics).filter_by(id=postdata["id"]).first()
            if None is tactics:
                raise Exception("策略不存在{}".format(postdata["id"])) 

            if "owner" in postdata:
                tactics.owner = postdata["owner"]
            if "name" in postdata:
                tactics.name = postdata["name"]
            if "source" in postdata:
                tactics.source = postdata["source"]
            if "doc" in postdata:
                tactics.doc = postdata["doc"]
            if "code" in postdata:
                path = '/code/tactics/'+postdata["id"]+'.py'
                pwd = os.getcwd()+path
                with open(pwd, 'w', encoding='utf-8') as f:
                    f.write(postdata["code"])
                    tactics.source = path

            session.add(tactics)
            session.commit()
            
            return unit.Response_headers(json.dumps({"code": 200, "data":"ok"}))
    except Exception as e:
        return json.dumps({"code": -1,"data":str(e)})

@tactics.route('/exit' , methods=["GET"])
def exit():
    try:
        if request.method == 'GET':
            tacticid = request.args.get("id")
            if None is tacticid:
               raise Exception("策略id不能为空")
            argv = request.args.get("argv")

            if None is argv:
               argv = ""
            tactics = session.query(Tactics).filter_by(id=tacticid).first()
            dtactics = unit.to_json(tactics,tactics.__class__)
            pwd = os.getcwd()+dtactics["source"]
            info = unit.decode(subprocess.check_output([EXEC, pwd, argv], stderr=subprocess.STDOUT, timeout=55))
            print(info)
            path = '~/share/tem/tem.csv'
            tem = pd.read_csv(path,dtype={"date":"string"}, index_col=0)
            outdata = tem.to_json(orient='records')
            result = json.loads(outdata,strict=False)
            print(result)
            return json.dumps({"code": 200,"data":result})
    except Exception as e:
        return json.dumps({"code": -1,"data":str(e)})

import sys, logging
from flask import Blueprint

import json,os,subprocess,sys
from flask import request
import pandas as pd

sys.path.append("..") 
from models import Tactics,TacticsInput
from database import session
from .unit import get_post_data,Response_headers,to_json,decode

EXEC = sys.executable
tactics = Blueprint('tactics', __name__)

spath = os.path.join(os.getcwd(),"code", "tactics")

@tactics.route('/list' , methods=["GET"])
def list():
    try:
        if request.method == 'GET':
 
            tactics = Tactics.query.all()
            list = []
            for data in tactics:
                list.append(to_json(data,data.__class__)) 
            return Response_headers(json.dumps({"code": 200, "data":list}))
    except Exception as e:
        logging.error(str(e))
        return json.dumps({"code": -1,"data":str(e)})

@tactics.route('/detailed' , methods=["GET"])
def detailed():
    try:
        if request.method == 'GET':
            tacticid = request.args.get("id")
            if None is tacticid:
               raise Exception("策略id不能为空")
            tactics = session.query(Tactics).filter_by(id=tacticid).first()
            dtactics = to_json(tactics,tactics.__class__)
            pwd = dtactics["source"]
            if os.path.exists(pwd):
                f = open(pwd,'rb')
                dtactics["code"] = f.read().decode(encoding='UTF-8',errors='strict')
                f.close()
            params = []
            tacticsInputs = session.query(TacticsInput).filter_by(tacticsId=tacticid)
            for data in tacticsInputs:
                params.append(to_json(data,data.__class__)) 
            dtactics["params"] = params
            return Response_headers(json.dumps({"code": 200, "data":dtactics}))
    except Exception as e:
        logging.error(str(e))
        return json.dumps({"code": -1,"data":str(e)})


@tactics.route('/add' , methods=["POST"])
def add():
    try:
        if request.method == 'POST':
            postdata = get_post_data(request)
            tactics = Tactics()
        
            tactics.name = postdata["name"]
            if "source" in postdata:
                tactics.source = postdata["source"]
            if "doc" in postdata:
                tactics.doc = postdata["doc"]
            if "owner" in postdata:
                tactics.owner = postdata["owner"]
     
            session.add(tactics)
            session.commit()
            
            return Response_headers(json.dumps({"code": 200, "data":"ok"}))
    except Exception as e:
        logging.error(str(e))
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
                path = os.path.join(spath,'{0}.py'.format(postdata["id"])) 
                with open(path, 'w', encoding='utf-8') as f:
                    f.write(postdata["code"])
                    tactics.source = path

            session.add(tactics)
            session.commit()
            
            return Response_headers(json.dumps({"code": 200, "data":"ok"}))
    except Exception as e:
        logging.error(str(e))
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
            dtactics = to_json(tactics,tactics.__class__)
            pwd = dtactics["source"]
            info = decode(subprocess.check_output([EXEC, pwd, argv], stderr=subprocess.STDOUT, timeout=55))
            print(info)
            path = '~/share/tem/tem.csv'
            tem = pd.read_csv(path,dtype={"date":"string"}, index_col=0)
            outdata = tem.to_json(orient='records')
            result = json.loads(outdata,strict=False)
            print(result)
            return json.dumps({"code": 200,"data":result})
    except Exception as e:
        return json.dumps({"code": -1,"data":str(e)})

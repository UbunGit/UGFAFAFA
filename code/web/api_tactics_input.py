import sys
sys.path.append("..") 

from flask import Blueprint
from .unit import get_post_data,Response_headers,to_json,decode
import json,os
from flask import request
from models import TacticsInput
from database import session

tacticsInput = Blueprint('tacticsInput', __name__)

@tacticsInput.route('/list' , methods=["GET"])
def list():
    try:
        if request.method == 'GET':
            tacticsId = request.args.get("tacticsId")
            inputs =  TacticsInput.query.filter_by(tacticsId=tacticsId)
            list = []
            for data in inputs:
                list.append(unit.to_json(data,data.__class__)) 
            return unit.Response_headers(json.dumps({"code": 200, "data":list}))
    except Exception as e:
        return json.dumps({"code": -1,"data":str(e)})

@tacticsInput.route('/detailed' , methods=["GET"])
def detailed():
    try:
        if request.method == 'GET':
            inputid = request.args.get("id")
            if None is inputid:
               raise Exception("策略id不能为空")
            input = session.query(TacticsInput).filter_by(id=inputid).first()
            inputs = to_json(input,input.__class__)
            return Response_headers(json.dumps({"code": 200, "data":inputs}))
    except Exception as e:
        return json.dumps({"code": -1,"data":str(e)})

@tacticsInput.route('/delete' , methods=["POST"])
def delete():
    try:
        if request.method == 'POST':
            postdata = unit.get_post_data(request)
            inputid = postdata["id"]
            if None is inputid:
               raise Exception("策略id不能为空")

            input=TacticsInput.query.get(inputid)
            session.delete(input)
            session.commit()
            return unit.Response_headers(json.dumps({"code": 200, "data":"ok"}))
    except Exception as e:
        return json.dumps({"code": -1,"data":str(e)})


@tacticsInput.route('/add' , methods=["POST"])
def add():
    try:
        if request.method == 'POST':
            postdata = get_post_data(request)
            input = TacticsInput()
            input.title = postdata["title"]
            input.name = postdata["name"]
            input.type = postdata["type"]
            input.defual = postdata["defual"]
            input.tacticsId = postdata["tacticsId"]
            session.add(input)
            session.commit()
            return Response_headers(json.dumps({"code": 200, "data":"ok"}))
    except Exception as e:
        return json.dumps({"code": -1,"data":str(e)})

@tacticsInput.route('/update' , methods=["POST"])
def update():
    try:
        if request.method == 'POST':
            postdata = get_post_data(request)
            if None is postdata["id"]:
                raise Exception("策略入参id不能为空") 
            input = session.query(TacticsInput).filter_by(id=postdata["id"]).first()
            if None is input:
                raise Exception("策略入参不存在{}".format(postdata["id"])) 

            if "title" in postdata:
                input.title = postdata["title"]
            if "name" in postdata:
                input.name = postdata["name"]
            if "type" in postdata:
                input.type = postdata["type"]
            if "defual" in postdata:
                input.defual = postdata["defual"]

            session.add(input)
            session.commit()
            
            return Response_headers(json.dumps({"code": 200, "data":"ok"}))
    except Exception as e:
        return json.dumps({"code": -1,"data":str(e)})
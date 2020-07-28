from flask import Blueprint
import unit
import json
from flask import request
from models import Tactics
from database import db_session as session

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


@tactics.route('/add' , methods=["POST"])
def add():
    try:
        if request.method == 'POST':
            postdata = unit.get_post_data(request)
            owner = postdata["owner"]
            name = postdata["name"]
            source = postdata["source"]
            doc = postdata["doc"]
            tactics = Tactics(owner, name,  source, doc)
            session.add(tactics)
            session.commit()
            
            return unit.Response_headers(json.dumps({"code": 200, "data":"ok"}))
    except Exception as e:
        return json.dumps({"code": -1,"data":str(e)})

@tactics.route('/update' , methods=["POST"])
def add():
    try:
        if request.method == 'POST':
            postdata = unit.get_post_data(request)
            if None is postdata["id"]:
                raise Exception("策略id不能为空") 
            tactics = session.query(Tactics).filter_by(id=postdata["id"]).first()
            if None is tactics:
                raise Exception("策略不存在{}".format(postdata["id"])) 

            if postdata["owner"] is not None:
                tactics.owner = postdata["owner"]
            if postdata["name"] is not None:
                tactics.name = postdata["name"]
            if postdata["source"] is not None:
                tactics.source = postdata["source"]
            if postdata["doc"] is not None:
                tactics.doc = postdata["doc"]

            session.add(tactics)
            session.commit()
            
            return unit.Response_headers(json.dumps({"code": 200, "data":"ok"}))
    except Exception as e:
        return json.dumps({"code": -1,"data":str(e)})
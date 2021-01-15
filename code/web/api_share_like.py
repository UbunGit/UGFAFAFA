import json
import sys

from flask import Blueprint
from flask import request
from flask import jsonify

sys.path.append("..") 

from .unit import *
from database import  session
from models import ShareLikeCategory

sharelike = Blueprint('sharelike', __name__)

@sharelike.route('/addcategory' , methods=["POST"])
def addcategory():
    try:
        if request.method == 'POST':
            postdata = unit.get_post_data(request)

            shareLikeCategory = ShareLikeCategory()
            shareLikeCategory.name = postdata["name"]
            session.add(shareLikeCategory)
            session.commit()
            return unit.Response_headers(json.dumps({"code": 200, "data":"ok" }))
    except Exception as e:
        return json.dumps({"code": -1,"data":str(e)})
    


@sharelike.route('/listcategory' , methods=["GET"])
def listcategory():

    try:
        if request.method == 'GET':
            name = request.args.get("name")
            shareLikeCategorys =  ShareLikeCategory.query.all()
            list = []
            for data in shareLikeCategorys:
                list.append(unit.to_json(data,data.__class__)) 
            return unit.Response_headers(json.dumps({"code": 200, "data":list}))
    except Exception as e:
        return json.dumps({"code": -1,"data":str(e)})
    

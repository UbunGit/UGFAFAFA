from flask import Blueprint
from .unit import *
import json
share = Blueprint('share', __name__)

@share.route('/test' , methods=["GET", "POST"])
def test():
    return unit.Response_headers(json.dumps({"code": 200,"data":"test"}))
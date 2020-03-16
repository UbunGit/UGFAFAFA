#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import logging
import time
import sys,os
from flask import Flask
from flask import request
from flask import Response
import json
import zxby
from flask_sqlalchemy import SQLAlchemy
from trade import share
from fitter import macdfitter

logpath = './log/main.log'
if os.path.isfile(logpath):
    os.remove(logpath)

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///./data/test.db'
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = True
db = SQLAlchemy(app)

logging.getLogger(__name__).setLevel(logging.DEBUG)
logging.basicConfig(format='%(message)s ' )
logging.debug(sys.version)

def Response_headers(content):
    resp = Response(content)
    resp.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization,session_id')
    resp.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS,HEAD')
    resp.headers.add('Content-Type', 'text/plain')
    resp.headers['Access-Control-Allow-Origin'] = '*'
    return resp

def decode(s):
    try:
        return s.decode('utf-8')
    except UnicodeDecodeError:
        return s.decode('gbk')
 
 # 根据时间获取股票交易历史数据
@app.route('/sharehistory')
def sharehistory():
    if request.method == 'GET':
        r = dict()
        r["code"] = -1
        try:
            code = request.args.get("code")
            begin = request.args.get("begin")
            cshare = share(code,begin)
            r["data"] =json.loads(cshare.cdata.to_json(orient='records')) 
            r["code"] = 0
            # r["data"] = str(request.args)

        except Exception as e:
            r["data"] = str(e)
        finally:
            print("======sharehistory======")
            print(r)
            print("============")
            return json.dumps(r)

 # 根据时间获取股票交易历史数据
@app.route('/fitterList')
def chooseList():
    if request.method == 'GET':
        r = dict()
        r["code"] = -1
        try:
            date = request.args.get("date")
            r["data"] =json.loads(macdfitter(date)) 
            r["code"] = 0
        except Exception as e:
            r["data"] = str(e)
        finally:
            print("======fitterList======")
            print(r)
            print("============")
            return json.dumps(r)
 

@app.route('/run', methods=['POST'])
def run():
    if request.method == 'POST' and request.form['code']:
        tcode = '000100'
        amount = 10000
        start = None
        end  = None
        parms =  request.form.to_dict()
        if 'tcode' in parms:
            tcode = parms['tcode']
        if 'amount' in parms:
            amount = parms['amount']
        if 'start' in parms:
            start = parms['start']
        if 'end' in parms:
            end = parms['end']
        code = request.form['code']
        jsondata = zxby.main(code= code,tcode = tcode,amount = amount,start = start,end = end)
        print("======run======")
        print(jsondata)
        print("============")
        return json.dumps(jsondata)
    return Response_headers(str("jsondata"))
 
@app.route('/tactics')
def tactics():
    return json.dumps(jsondata)
 
@app.errorhandler(403)
def page_not_found(error):
    content = json.dumps({"error_code": "403"})
    resp = Response_headers(content)
    return resp
 
 
@app.errorhandler(404)
def page_not_found(error):
    content = json.dumps({"error_code": "404"})
    resp = Response_headers(content)
    return resp
 
 
@app.errorhandler(400)
def page_not_found(error):
    content = json.dumps({"error_code": "400"})
    resp = Response_headers(content)
    return resp
 
 
@app.errorhandler(405)
def page_not_found(error):
    content = json.dumps({"error_code": "405"})
    resp = Response_headers(content)
    return resp
 
 
@app.errorhandler(410)
def page_not_found(error):
    content = json.dumps({"error_code": "410"})
    resp = Response_headers(content)
    return resp
 
 
@app.errorhandler(500)
def page_not_found(error):
    content = json.dumps({"error_code": "500"})
    resp = Response_headers(content)
    return resp



# 定义策略Tactics对象:
class BaseModel(object):
    def to_json(self):
        fields = self.__dict__
        if "_sa_instance_state" in fields:
            del fields["_sa_instance_state"]
        
        return fields

class Tactics(db.Model,BaseModel):
    __tablename__ = 'tactics'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50))
    categories = db.Column(db.Integer)
    remark = db.Column(db.String(512))


 
 
if __name__ == '__main__':
    
    app.run(debug=True)


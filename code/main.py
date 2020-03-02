import logging
import time
import sys
from flask import Flask
from flask import request
from flask import Response
import json
import zxby

# logging.basicConfig(format='%(asctime)s %(message)s ', filename='sequoia.log')

logging.basicConfig(format='%(asctime)s %(message)s ')
logging.getLogger().setLevel(logging.DEBUG)

logging.debug(sys.version)

 
app = Flask(__name__)
 
 
def Response_headers(content):
    resp = Response(content)
    resp.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization,session_id')
    resp.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS,HEAD')
    resp.headers.add('Content-Type', 'text/plain')
    resp.headers['Access-Control-Allow-Origin'] = '*'
    return resp
 
 
@app.route('/')
def hello_world():
    return Response_headers('hello world!!!')
 
 
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
        return json.dumps(jsondata)
    return Response_headers(str("jsondata"))
 
 
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
 
 
if __name__ == '__main__':
    app.run(debug=True)

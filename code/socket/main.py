#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys,os,time
import logging
import importlib

from flask import Flask  
from flask import request,jsonify  
from flask_cors import CORS  
from flask_socketio import SocketIO,send,emit  
import urllib.parse  
from imp import reload

codepath = os.path.join(os.getcwd(),"code")
# os.path.join()

sys.path.append(codepath)

app = Flask(__name__)  

app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app,cors_allowed_origins='*')  

@socketio.on('message')  
def handle_message(message):
    try:
        print(message) 
        modulestr = "tactics.{}".format(message.get("id"))
        mod =reload(importlib.import_module(modulestr)) 
        shares = mod.setup(param = message.get("param"))
        if shares == []:
            emit('error', "获取数据失败")
            print("error 获取数据失败")
            return
        last = None
        for item in shares:
            data = mod.seller(item)
            data = mod.buy(data)
            data = mod.summary(data)
            last = data
            emit('message', data)
            socketio.sleep(0.1)
            
        finesh = mod.finesh()
        emit('finesh',finesh)
        logging.debug('finesh {}'.format(finesh))
    except Exception as e:
            logging.warning("real error%s",e)
            emit('error', "exceptin:{}".format(e))
    
@socketio.on('connect', namespace=None)  
def test_connect():  
    emit('my response', {'data': 'Connected'})  

@socketio.on('disconnect', namespace=None)  
def test_disconnect():  
    print('Client disconnected')  

if __name__ == '__main__':  
    socketio.run(app,debug=True,host="0.0.0.0",port=8081)
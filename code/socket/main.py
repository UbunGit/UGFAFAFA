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

sys.path.append("..")

app = Flask(__name__)  

app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app,cors_allowed_origins='*')  

@socketio.on('message')  
def handle_message(message):
    print('message0') 
    message = urllib.parse.unquote(message)
    mod = importlib.import_module("tactics.{}".format(message))
    param={
            'code': "300022.SZ",
            'begin': '20200107',
            'end': '20210607',
            'money': 20000
            }
    shares = mod.setup(param)
    for item in shares:
     
        data = mod.seller(item)
        data = mod.buy(data)
        data = mod.summary(data)
        emit('message', data)
        print(data) 
        socketio.sleep(0.1)
        
    
    

@socketio.on('connect', namespace=None)  
def test_connect():  
    emit('my response', {'data': 'Connected'})  

@socketio.on('disconnect', namespace=None)  
def test_disconnect():  
    print('Client disconnected')  



if __name__ == '__main__':  
    socketio.run(app,debug=True,host="0.0.0.0",port=8081)
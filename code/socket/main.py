#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import datetime
import json
from flask_cors import CORS  
from flask_socketio import Namespace, emit, SocketIO, disconnect
from flask import Flask, render_template,request



app = Flask(__name__)
CORS(app,cors_allowed_origins="*") 
app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app, cors_allowed_origins='*')

if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', port=8081, debug=True)


def ack():
    print ('message was received!')

@socketio.on('connect', namespace='/test')
def test_connect():
    emit('my response', {'data': 'Connected'})

@socketio.on('disconnect', namespace='/test')
def test_disconnect():
    print('Client disconnected')

@socketio.on('message')
def handle_message(message):
    print('handle_message: ')
    send(message)

@socketio.on('json')
def handle_json(json):
    print('handle_json: ')
    send(json, json=True)

@socketio.on('my event')
def handle_my_custom_event(json):
    print('received json: ')
    emit('handle_my_custom_event', json,callback=ack)






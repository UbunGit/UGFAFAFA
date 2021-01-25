#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from flask_cors import CORS  
from flask import Flask, render_template
from flask_socketio import SocketIO ,emit,send

app = Flask(__name__)
# CORS(app,cors_allowed_origins="*") 
app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app, cors_allowed_origins='*')


@socketio.on('connect', namespace=None)
def test_connect():
    print('test_connect')
    emit('message', "data")
    print('emit')
    

@socketio.on('disconnect', namespace=None)
def test_disconnect():
    print('Client disconnected')

@socketio.on('message')
def handle_message(message):
    print('message')
    emit('message', "data ====")

if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', debug=True)














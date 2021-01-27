import socketio

sio = socketio.Client()

@sio.event
def connect():
    print('connection established')
    sio.emit('message', 'response my response')

@sio.event
def message(data):
    print('message received with ', data)
    sio.emit('message', 'response my response')

@sio.event
def disconnect():
    print('disconnected from server')

sio.connect('http://10.10.11.171:5000')
sio.wait()
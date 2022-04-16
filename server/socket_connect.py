import main


def emit_socket(message):
    return main.socketio_socket.emit('new_message', message)

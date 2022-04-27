from datetime import date, datetime
import json
from socket import socket
from flask import request, Blueprint, jsonify
from flask_restx import Api, Resource
from server.data import *
from flask_jwt_extended import (
    create_access_token,
    unset_jwt_cookies,
    jwt_required,
    get_jwt_identity,
)
import bcrypt
from flask_socketio import emit, send


api_blueprint = Blueprint("api", __name__, url_prefix="/api")
api = Api(api_blueprint)

from server import socketio_socket



# @api.route("/messages")
# class Message(Resource):
#     def get(self):

#         return jsonify(getMessages())

#     def post(self):
#         req_data = request.get_json()
#         userId = req_data["userId"]
#         text = req_data["text"]
#         topic = req_data["topic"]

#         message = createMessage(userId, text, topic)
#         # broadcast message
#         emit("new_message", message)
#         return jsonify(message)


@socketio_socket.on("connect")
def test_connect():
    print("connected")

@socketio_socket.on("new_message")
# def get():
#     return jsonify(getMessages())

def post(msg):
    
    userId = msg['userId']
    text = msg['text']
    topic = msg['topic']

    message = createMessage(userId, text, topic)
    # broadcast message
    theMessage = jsonify(message)
    socketio_socket.emit("new_message", msg)
    print(msg)
    print(json.dumps(message))
    return jsonify(message)

@socketio_socket.on("get_messages_by_topic")
def get_topic(topic):
    messages = getMessagesByTopic(topic)
    # print(topic)
    # print((messages))
    def myconverter(o):
        if isinstance(o, date):
            return o.__str__()
    socketio_socket.emit("get_messages_by_topic", json.dumps(messages, default=myconverter))
    return jsonify(messages)

@api.route("/users")
class GetAllUsers(Resource):
    # @jwt_required()
    def get(self):

        return jsonify(getUsers())

    def post(self):
        req_data = request.get_json()
        username = req_data["username"]
        password = req_data["password"]

        return jsonify(createUser(username, password))


@api.route("/users/<id>")
class GetSingleUser(Resource):
    def get(self, id):

        return jsonify(getSingleUser(id))


@api.route("/messages/<topic>")
class GetMessagesByTopic(Resource):
    def get(self, topic):
        return jsonify(getMessagesByTopic(topic))




@api.route("/token", methods=["POST"])
class CreateToken(Resource):
    def post(self):

        req_data = request.get_json()
        username = req_data["username"]
        password = req_data["password"]

        for i in checkUser(username):
            if i["username"] == username and bcrypt.checkpw(
                password.encode(), i["password"].encode()
            ):

                access_token = create_access_token(identity=username)
                response = {"access_token": access_token}
                return response

        return {"msg": "Username or password incorrect"}, 401


@api.route("/logout", methods=["POST"])
class Logout(Resource):
    def post(self):
        response = jsonify({"msg": "logout successful"})
        unset_jwt_cookies(response)
        return response


@api.route("/activeusers")
class activeUsers(Resource):
    def get(self):

        return jsonify(getActiveUsers())

@socketio_socket.on("activateUser")
def activate(user):

    # req_data = request.get_json()
    username = user['username']
    activatedUsers = activateUser(username)
    socketio_socket.emit("activateUser", username)

    return jsonify(activatedUsers)



# @api.route("/activateuser", methods=["POST"])
# class activeUsers(Resource):
#     def post(self):

#         req_data = request.get_json()
#         username = req_data["username"]

#         return jsonify(activateUser(username))


# @api.route("/deactivateuser", methods=["POST"])
# class activeUsers(Resource):
#     def post(self):

#         req_data = request.get_json()
#         username = req_data["username"]

#         return jsonify(deactiveUser(username))

@socketio_socket.on("deactivateUser")
def deactivate(user):

    # req_data = request.get_json()
    username = user['username']
    deactivatedUser = deactiveUser(username)
    socketio_socket.emit("deactivateUser", username)
    print("user is deactivated")

    return jsonify(deactivatedUser)

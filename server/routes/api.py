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


# def emit_socket(message):
#     print(message)
#     return server.main.socketio_socket.emit("new_message", message)


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


# @socketio_socket.on("connect")
# def test_connect():
#     print("connected")

# @socketio_socket.on("new_message")
# def get():

#     return jsonify(getMessages())
# def post():
#     req_data = request.get_json()
#     userId = req_data["userId"]
#     text = req_data["text"]
#     topic = req_data["topic"]

#     message = createMessage(userId, text, topic)
#     # broadcast message
#     emit("new_message", message)
#     print(message)
#     return jsonify(message)


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


@socketio_socket.on("get_message_by_topic")
def get(topic):
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


@api.route("/activateuser", methods=["POST"])
class activeUsers(Resource):
    def post(self):

        req_data = request.get_json()
        username = req_data["username"]

        return jsonify(activateUser(username))


@api.route("/deactivateuser", methods=["POST"])
class activeUsers(Resource):
    def post(self):

        req_data = request.get_json()
        username = req_data["username"]

        return jsonify(deactiveUser(username))

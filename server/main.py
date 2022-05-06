from distutils.log import debug
import imp
from flask import send_from_directory
from flask_restx import Api, Resource
from datetime import date, datetime, timedelta
import os
from flask import request, jsonify
from flask_jwt_extended import (
    JWTManager,
    get_jwt,
    get_jwt_identity,
    create_access_token,
)
import json
from server.data import *

from server import create_app, socketio_socket
app = create_app()


@app.after_request
def refresh_expiring_jwts(response):
    try:
        exp_timestamp = get_jwt()["exp"]
        now = datetime.utcnow()
        target_timestamp = datetime.timestamp(now + timedelta(minutes=30))
        if target_timestamp > exp_timestamp:
            access_token = create_access_token(identity=get_jwt_identity())
            data = response.get_json()
            if type(data) is dict:
                data["access_token"] = access_token
                response.data = json.dumps(data)
        return response

    except (RuntimeError, KeyError):
        return response


@app.route("/", defaults={"path": ""})
@app.route("/<path:path>")
def serve(path):

    return send_from_directory(app.static_folder, "index.html")


if __name__ == "__main__":
    socketio_socket.run(app, debug=True)

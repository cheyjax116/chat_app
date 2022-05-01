import psycopg2
import os

def get_connection():
    return psycopg2.connect(
            host=os.environ.get("DB_HOST"),
            port=os.environ.get("DB_PORT"),
            database=os.environ.get("DB_DATABASE"),
            user=os.environ.get("DB_USER"),
            password=os.environ.get("DB_PASSWORD"),
            sslmode=os.environ.get("DB_SSLMODE")
        )
# def get_connection():
#     return psycopg2.connect(
#             host="localhost",
#             port=5432,
#             database="chat_app",
#             user="postgres",
#             password=os.environ.get("PASSWORD"),
#             # sslmode=os.environ.get("DB_SSLMODE")
#         )
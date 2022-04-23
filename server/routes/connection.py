import bcrypt
from server.db_connection import get_connection


def getUsersConnection():

    connection = get_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT username, id, signedIn FROM users")
    columns = cursor.description
    records = [
        {columns[index][0]: column for index, column in enumerate(value)}
        for value in cursor.fetchall()
    ]
    return records


def createUserConnection(username, password):

    connection = get_connection()

    hashedPassword = bcrypt.hashpw(password.encode(), bcrypt.gensalt())
    stringedHashedPassword = hashedPassword.decode()
    cursor = connection.cursor()
    cursor.execute(
        "INSERT INTO users (username, password) VALUES (%s, %s)",
        (username, stringedHashedPassword,)
    )
    connection.commit()
    cursor.close()
    connection.close()


def getSingleUserConnection(id):

    connection = get_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT username,id FROM users WHERE Id=%s", (id))
    columns = cursor.description
    records = [
        {columns[index][0]: column for index, column in enumerate(value)}
        for value in cursor.fetchall()
    ]
    return records


def getMessagesConnection():
    connection = get_connection()

    # formattedTime = "formatted_time"
    # formattedDate = "formatted_date"

    cursor = connection.cursor()
    cursor.execute(
        """SELECT *, to_char (time_created, 'HH:MI PM') AS "formatted_time", 
        to_char (createddate, 'MM/DD/YY') AS "formatted_date" FROM messages ORDER BY "formatted_date" ASC""",
        # (formattedTime, formattedDate, formattedDate,)
    )
    columns = cursor.description
    records = [
        {columns[index][0]: column for index, column in enumerate(value)}
        for value in cursor.fetchall()
    ]
    return records


def getSingleMessageConnection(messageId):
    connection = get_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM messages WHERE messageid=%s", (messageId))
    columns = cursor.description
    records = [
        {columns[index][0]: column for index, column in enumerate(value)}
        for value in cursor.fetchall()
    ]
    return records


def createMessageConnection(userId, text, topic):
    connection = get_connection()

    cursor = connection.cursor()
    cursor.execute(
        "INSERT INTO messages (userid, text, topic) VALUES (%s, %s, %s)",
        (userId, text, topic)
    )
    connection.commit()
    cursor.close()
    connection.close()


def getMessagesByTopicConnection(topic):

    connection = get_connection()

    # formattedDate = "formatted_date"

    cursor = connection.cursor()
    cursor.execute(
        """SELECT *, to_char (createddate, 'Day, Month fmDDth, YYYY') AS "formatted_date" FROM messages WHERE topic=%s ORDER BY messageid ASC""", 
        (topic,)
    )
    columns = cursor.description
    records = [
        {columns[index][0]: column for index, column in enumerate(value)}
        for value in cursor.fetchall()
    ]
    return records


def checkUserConnection(username):

    connection = get_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT username, password FROM users WHERE username=%s", (username,))
    columns = cursor.description
    records = [
        {columns[index][0]: column for index, column in enumerate(value)}
        for value in cursor.fetchall()
    ]
    return records


def getActiveUsersConnection():

    connection = get_connection()

    cursor = connection.cursor()
    cursor.execute("SELECT username from users where signedin='Yes'")
    columns = cursor.description
    records = [
        {columns[index][0]: column for index, column in enumerate(value)}
        for value in cursor.fetchall()
    ]
    return records


def activateUserConnection(username):

    connection = get_connection()

    cursor = connection.cursor()
    cursor.execute("update users set signedin='Yes' where username=%s", (username,))
    connection.commit()
    cursor.close()
    connection.close()


def deactivateUserConnection(username):

    connection = get_connection()

    cursor = connection.cursor()
    cursor.execute("update users set signedin='No' where username=%s", (username,))
    connection.commit()
    cursor.close()
    connection.close()



import React, { useEffect, useState } from "react";
import { Button } from "react-bootstrap";
import "./ChatInterface.css";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import useToken from "./useToken";
import useUser from "./useUser";
import io from "socket.io-client";
import { DateTime } from "luxon";
import TopicButton from "./TopicButton";

const ChatInterface = () => {
  window.setTimeout(function () {
    let element = document.getElementById("chatBox");
    element.scrollTop = element.scrollHeight;
  });

  const [currentTopic, setCurrentTopic] = useState("General");

  const [messages, setMessages] = useState([]);

  const [users, setUsers] = useState([]);

  const { removeToken } = useToken();

  const { signedInUser, signOutUser } = useUser();

  const [activeUsers, setActiveUsers] = useState([]);

  const [message, setMessage] = useState("");

  const [newMessageTopic, setNewMessageTopic] = useState("");

  const [newMessage, setNewMessage] = useState({
    General: false,
    Art: false,
    "Film & TV": false,
    Music: false,
    Sports: false,
  });

  let navigate = useNavigate();

  const getUserInfo = (user_id) => {
    return users.find((user) => user.id === user_id);
  };

  const selectSignedInUser = (signedInUser) => {
    let theUserId;
    users.find((user) => {
      if (user.username === signedInUser) {
        theUserId = user.id;
      }
    });
    return theUserId;
  };

  async function getMessages() {
    await axios.get(`api/messages/${currentTopic}`).then((res) => {
      setMessages(res.data);
    });
  }

  async function getUsers() {
    await axios.get("api/users").then((res) => {
      setUsers(res.data);
    });
  }

  async function getActiveUsers() {
    await axios.get("api/activeusers").then((res) => {
      setActiveUsers(res.data);
    });
  }

  const actives = activeUsers?.map((user) => {
    return (
      <table className="d-flex text-center justify-content-center align-items-center pb-2">
        <td
          style={
            user?.username === signedInUser
              ? { color: "#ffa861", fontWeight: "bold" }
              : { color: "#bafad4" }
          }
        >
          {user?.username === signedInUser
            ? user?.username + " (You)"
            : user?.username}
        </td>
        <br></br>
      </table>
    );
  });

  const data = messages?.map((message) => {
    return {
      ...message,
      user: getUserInfo(message?.userid),
    };
  });

  let userId = selectSignedInUser(signedInUser);

  function dateSuffix(date) {
    if (date > 3 && date < 21) return `${date}th`;
    switch (date % 10) {
      case 1:
        return `${date}st`;
      case 2:
        return `${date}nd`;
      case 3:
        return `${date}rd`;
      default:
        return `${date}th`;
    }
  }

  const convertDate = (date) => {
    const weekday = DateTime.fromISO(date).toFormat("EEEE");
    const year = DateTime.fromISO(date).toFormat("yyyy");
    const day = dateSuffix(DateTime.fromISO(date).toFormat("d"));
    const month = DateTime.fromISO(date).toFormat("MMMM");

    return `${weekday}, ${month} ${day}, ${year}`;
  };

  const databaseSend = () => {
    let messageBox = document.getElementById("messageBox");

    if (message !== "") {
      socket.emit("new_message", {
        userId: userId,
        text: message,
        topic: currentTopic,
      });
    }
    setMessage("");
    messageBox.value = "";
  };

  const logOut = () => {
    axios
      .post("/api/logout", data, {
        headers: {
          Accept: "application/json",
          "Content-Type": "application/json",
        },
      })
      .then((res) => {
        removeToken();
        socket.emit("deactivateUser", { username: signedInUser });
        signOutUser();
        navigate("/");
        window.location.reload();
      })
      .catch((error) => {
        console.log("An error was caught!", error);
      });
  };

  useEffect(() => {
    getMessages();
    getUsers();
    getActiveUsers();
  }, [currentTopic]);

  const socket = io.connect();

  useEffect(() => {
    if (newMessageTopic === currentTopic) {
      setNewMessage((previousState) => {
        const newState = { ...previousState, [newMessageTopic]: false };
        return newState;
      });
    }
    setNewMessageTopic("");
  }, [newMessageTopic]);

  useEffect(() => {
    let newSocket = io.connect();
    socket.on("connect", () => {
      // console.log("Connected...")
    });
    newSocket.on("new_message", (message) => {
      setMessages((messages) => [...messages, message[0]]);

      setNewMessageTopic(message[0].topic);

      setNewMessage((previousState) => {
        const newState = { ...previousState, [message[0].topic]: true };
        return newState;
      });
    });

    socket.on("activateUser", () => {
      getActiveUsers();
    });

    socket.on("deactivateUser", () => {
      getActiveUsers();
    });
  }, []);

  const formatTime = (utcTime) => {
    const time = DateTime.fromISO(utcTime).toFormat("t");
    return time;
  };

  const filteredData = data.filter((message) => {
    if (message.topic === currentTopic) {
      return message;
    }
  });

  const theMessages =
    filteredData &&
    filteredData.map((message, index) => {
      let prev = data[index - 1];
      let current = data[index];

      return (
        <div>
          {prev?.createddate === current?.createddate ? (
            ""
          ) : (
            <div>
              <div className="fw-bold mx-auto horizontalLine"></div>
              <div className="fw-bold mt-4" style={{ color: "#444c55" }}>
                {convertDate(message?.createddate)}
              </div>
            </div>
          )}

          <div
            className="chat-container"
            style={
              message.user?.username === signedInUser
                ? { background: "#e45437" }
                : { background: "" }
            }
            key={index}
          >
            <div
              className="card-header d-flex justify-content-between p-3"
              style={{ borderBottom: "1px solid rgba(255, 255, 255, 0.3" }}
            >
              <p className="fw-bold mb-0 paddingRight">
                {message?.user?.username}
              </p>
              <p className=" small mb-0">
                <i>{formatTime(message?.time_created)}</i>
              </p>
            </div>
            <div className="card-body">
              <p className="mb-0 mx-auto p-2">{message.text}</p>
            </div>
          </div>
        </div>
      );
    });

  return (
    <>
      <div id="container">
        <div className="text-center mx-auto" id="navbar">
          {currentTopic}
        </div>

        <div className="userBox col-3 userText">
          <h6 className="text-center p-3 mt-2 pb-1">Active Users</h6>
          <p className="text-center">{actives}</p>

          <h6 className="text-center p-3">Topics</h6>

          <TopicButton
            topicName={"General"}
            currentTopic={currentTopic}
            setCurrentTopic={setCurrentTopic}
            newMessage={newMessage.General}
            setNewMessage={setNewMessage}
          />
          <TopicButton
            topicName={"Art"}
            currentTopic={currentTopic}
            setCurrentTopic={setCurrentTopic}
            newMessage={newMessage.Art}
            setNewMessage={setNewMessage}
          />
          <TopicButton
            topicName={"Film & TV"}
            currentTopic={currentTopic}
            setCurrentTopic={setCurrentTopic}
            newMessage={newMessage["Film & TV"]}
            setNewMessage={setNewMessage}
          />
          <TopicButton
            topicName={"Music"}
            currentTopic={currentTopic}
            setCurrentTopic={setCurrentTopic}
            newMessage={newMessage.Music}
            setNewMessage={setNewMessage}
          />
          <TopicButton
            topicName={"Sports"}
            currentTopic={currentTopic}
            setCurrentTopic={setCurrentTopic}
            newMessage={newMessage.Sports}
            setNewMessage={setNewMessage}
          />

          <Button
            className="p-2 d-flex justify-content-center align-items-center mx-auto mb-4 logoutBtn"
            onClick={logOut}
          >
            Logout
          </Button>
        </div>

        <div className="parent">
          <div className="discussionBox" id="chatBox">
            {theMessages}
          </div>

          <div className="flex child">
            <div>
              <div className="input-group">
                <textarea
                  id="messageBox"
                  type="text"
                  className="form-control messageBox"
                  rows="2"
                  cols="500"
                  onChange={(e) => {
                    setMessage(e.target.value);
                  }}
                  value={message}
                  placeholder="Type Your Message"
                  onKeyUp={(e) => {
                    if (e.key === "Enter") {
                      databaseSend();
                    }
                  }}
                />
              </div>
            </div>
            <Button
              type="submit"
              className="btn sendBtn"
              onClick={databaseSend}
            >
              SEND
            </Button>
          </div>
        </div>
      </div>
    </>
  );
};

export default ChatInterface;

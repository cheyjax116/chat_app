import React from "react";
import { Button } from "react-bootstrap";

const TopicButton = ({
  topicName,
  currentTopic,
  setCurrentTopic,
  newMessage,
  setNewMessage,
}) => {
  const newMessageIcon = (
    <div className="col-4 mt-2">
      <span className=" float-left newMessageButton p-2">New</span>
    </div>
  );



  return (
    <>
      <div className={newMessage ? "row justify-content-end" : "row justify-content-center align-items-center mx-auto"}>
        <div className="col-4 d-flex justify-content-center align-items-center">
          <Button
            className={
              currentTopic === topicName
                ? "p-2 mb-4 activeButton"
                : "p-2 mb-4"
            }
            autoFocus={topicName === "General" ? "True" : ""}
            id={topicName}
            onClick={(e) => {
              console.log(newMessage)

              setCurrentTopic(e.target.id);
              
              setNewMessage( newMessage => {
                const newState = { ...newMessage, [e.target.id]: false}
                console.log(newState)
                return newState
        })          
              
            }}
          >
            {topicName}
          </Button>
        </div>
        
        {newMessage ? newMessageIcon : null}
     
      </div>
    </>
  );
};

export default TopicButton;

// ? "p-2 d-flex justify-content-center align-items-center mx-auto mb-4 activeButton"
// : "p-2 d-flex justify-content-center align-items-center mx-auto mb-4"
// }
import './DeleteUser.css'
import React, { useState } from "react";
import LoadingSpinner from "../LoadingSpinner/LoadingSpinner.js"

export default function DeleteUser() {
  const [userNames, setuserNames] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState('');

  const handle2xx = (response) => {
    response.text().then(
      (resText) => {
        setIsLoading(false);
        setuserNames(JSON.parse(resText));
      }
    );
  };

  const handle4xx = (response) => {
    response.text().then(
      (resText) => {
        setIsLoading(false);
        setErrorMessage(resText);
      }
    );
  };

  const handleResponse = (response) => {
    if(response.status >= 200 && response.status < 300) { handle2xx(response); return }
    if(response.status >= 400 && response.status < 500) { handle4xx(response); return }
  };

  const handleClick = () => {
    setIsLoading(true);
    setErrorMessage('');
    setSuccessMessage('');
    fetch('/all_user_names',
      {
        method: 'get'
      }
    )
    .then((response) => handleResponse(response));  
  }

  const userList = (
    <ul>
      {userNames.map((userName) => (
        <li>{userName}</li>
      ))}
      {errorMessage && <div className="error">{errorMessage}</div>}
    </ul>
  )

  return (
    <div>
      <h1 className="App-header">Fetch User list</h1>

      {isLoading ? <LoadingSpinner /> : userList}
      <button onClick={handleClick} disabled={isLoading}>
        Fetch All userNames
      </button>
      
    </div>
  );
}
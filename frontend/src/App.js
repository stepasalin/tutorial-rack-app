import React, { useState } from "react";
import LoadingSpinner from "./spinner/LoadingSpinner";
// import "./styles.css";

export default function App() {
  const [userOutdated, setUserOutdated] = useState(true);
  const [inputValue, setInputValue] = useState('');
  const [user, setUser] = useState({});
  const [isLoading, setIsLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");
  const handleNameInputChange = (event) => {
    setInputValue(event.target.value)
  }
  const handleResponse = (response) => {
    if(response.status === 200) {
      response.text().then(
        (resText) => {
          setIsLoading(false);
          setUserOutdated(false);
          setUser(JSON.parse(resText));
        }
      )
    }
    if(response.status === 404) {
      response.text().then(
        (resText) => {
          setIsLoading(false);
          setUserOutdated(false);
          setUser({});
          setErrorMessage(resText);
        }
      )
    }
  };
  const handleFetch = () => {
    setIsLoading(true);
    setUserOutdated(true);
    setErrorMessage('');  
    fetch(`/raw_user/${inputValue}`)
      .then((response) => handleResponse(response));
  };
  const userForm = (
    <ul>
      <li>Name: {user.name}</li>
      <li>Gender: {user.gender}</li>
      <li>Age: {user.age}</li>
    </ul>
  )
  const renderUser = (
    <div className="userlist-container">
      {userOutdated ? <div/> : userForm }
      {errorMessage && <div className="error">{errorMessage}</div>}
    </div>
  );
  return (
    <div className="App">
      <h1>Search for user: {inputValue}</h1>
       <input
          type="text"
          id="id"
          name="name"
          onChange={handleNameInputChange}
          value={inputValue}
        />
      {isLoading ? <LoadingSpinner /> : renderUser}
      {/* {errorMessage && <div className="error">{errorMessage}</div>} */}
      <button onClick={handleFetch} disabled={isLoading}>
        Fetch User
      </button>
    </div>
  );
}
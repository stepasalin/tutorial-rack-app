import React, { useState } from "react";
import LoadingSpinner from "./spinner/LoadingSpinner";
// import "./styles.css";

export default function App() {
  const [inputValue, setInputValue] = useState('');
  const [user, setUser] = useState({});
  const [isLoading, setIsLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");
  const handleNameInputChange = (event) => {
    setInputValue(event.target.value)
  }
  const handleFetch = () => {
    setIsLoading(true);
    fetch(`/raw_user/${inputValue}`)
      .then((respose) => respose.json())
      .then((response) => {
         setUser(response)
         setIsLoading(false)
      })
      .catch(() => {
         setErrorMessage("Unable to fetch user");
         setIsLoading(false);
      });
  };
  const renderUser = (
    <div className="userlist-container">
      <ul>
        <li>Name: {user.name}</li>
        <li>Gender: {user.gender}</li>
        <li>Age: {user.age}</li>
      </ul>
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
      {errorMessage && <div className="error">{errorMessage}</div>}
      <button onClick={handleFetch} disabled={isLoading}>
        Fetch User
      </button>
    </div>
  );
}
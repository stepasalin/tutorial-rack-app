import './AddUser.css'
import React, { useState } from "react";
import LoadingSpinner from "../LoadingSpinner/LoadingSpinner.js"

export default function AddUser() {
  const [name, setName] = useState('');
  const [gender, setGender] = useState('');
  const [age, setAge] = useState('')
  const [isLoading, setIsLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState('');
  const [successMessage, setSuccessMessage] = useState('');

  const handleNameInputChange = (event) => {
    setName(event.target.value)
  }
  const handleGenderInputChange = (event) => {
    setGender(event.target.value)
  }
  const handleAgeInputChange = (event) => {
    setAge(event.target.value)
  }


  const handle2xx = (response) => {
    response.text().then(
      (resText) => {
        setIsLoading(false);
        setSuccessMessage(resText);
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

  const handleCreate = () => {
    setIsLoading(true);
    setErrorMessage('');
    setSuccessMessage('');
    const body = {
      "name":`${name}`,
      "gender":`${gender}`,
      "age":`${age}`
    }
    fetch('/user/new',
      {
        method: 'post',
        body: JSON.stringify(body)
      }
    )
    .then((response) => handleResponse(response));
  };

  const handleUpdate = () => {
    setIsLoading(true);
    setErrorMessage('');
    setSuccessMessage('');
    const body = {
      "name":`${name}`,
      "gender":`${gender}`,
      "age":`${age}`
    }
    fetch(`/user/update`,
      {
        method: 'put',
        body: JSON.stringify(body)
      }
    )
    .then((response) => handleResponse(response));
  };

  const inputForm = (
    <ul>
      <li>Name:
        <input
          type="text"
          id="name"
          onChange={handleNameInputChange}
          value={name}
        />
      </li>
      <li>Gender:
      <input
          type="text"
          id="gender"
          onChange={handleGenderInputChange}
          value={gender}
        />
      </li>
      <li>Age:
        <input
          type="text"
          id="age"
          onChange={handleAgeInputChange}
          value={age}
        />
      </li>
      {errorMessage && <div className="error">{errorMessage}</div>}
      {successMessage && <div className="success">{successMessage}</div>}
    </ul>
  )
  return (
    <div>
      <h1 className="App-header">Create/Update User</h1>

      {isLoading ? <LoadingSpinner /> : inputForm}
      <button onClick={handleCreate} disabled={isLoading}>
        Create User
      </button>
      <button onClick={handleUpdate} disabled={isLoading}>
        Update User
      </button>
    </div>
  );
}
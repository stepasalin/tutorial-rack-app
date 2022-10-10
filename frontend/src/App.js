import GetUser from './components/GetUser/GetUser.js'
import AddUser from './components/AddUser/AddUser.js'
import DeleteUser from './components/DeleteUser/DeleteUser.js'
import AllUsers from './components/AllUsers/AllUsers.js'
import React from "react";

export default function App() {
  
  return (
    <>
      <GetUser />
      <AddUser />
      <DeleteUser />
      <AllUsers />
    </>  
  );
}
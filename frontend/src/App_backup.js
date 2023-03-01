import React, { Component } from 'react';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      user: {},
      nameInputValue: '',
      isLoading: false
    };
  }
  handleNameInputChange(event){
    this.setState({ nameInputValue: event.target.value} )
  }

  sendRawUserRequest(){
    this.setState( {isLoding: true} );
    fetch(`/raw_user/${this.state.nameInputValue}`)
    .then(response => response.json())
    .then(json => this.setState( { user: json })) 
    this.setState( {isLoding: false} );
  }

  render() {
    const { nameInputValue } = this.state;
    const { user } = this.state;
    return (
      <div className="container">
        <div class="jumbotron">
          <h1 class="display-4">{nameInputValue}</h1>
        </div>
        <button onClick={this.sendRawUserRequest.bind(this)}>Search</button>
        <input
          type="text"
          id="user_name"
          name="user_name"
          onChange={this.handleNameInputChange.bind(this)}
          value={nameInputValue}
        />
        <RenderUser />
        {/* <div>
          <div className="card-header">
            <p className="card-text">Gender: {user.gender}</p>
            <p className="card-text">Age: {user.age}</p>
          </div>
        </div> */}
      </div>
    );
  }
}
export default App;
import gql from 'graphql-tag'
import {Query} from 'react-apollo'
import React, {Component} from 'react'

import logo from './logo.svg'
import './App.css'


const GET_NEURON = gql`
  {
    htm_neuron {
      id
      column_id
    }
  }
`

const Neurons = () => (
  <Query query={GET_NEURON}>
    {({loading, error, data}) => {
      if (loading) return 'Loading...'
      if (error) return `Error! ${error.message}`
      return (
        <p>
          {data.htm_neuron.map(neuron => (
            <div><b>{neuron.id}</b> {neuron.column_id}</div> 
          ))}
        </p>
      )
    }}
  </Query>
)


class App extends Component {
  render() {
    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <Neurons />
        </header>
      </div>
    )
  }
}


export default App


import {BrowserRouter, Redirect, Route, Switch} from 'react-router-dom'
import gql from 'graphql-tag'
import {Query} from 'react-apollo'
import React from 'react'

import './App.css'


const GET_COLUMNS = gql`
  {
    htm_column {
      id
      region_id
      x_coord
    }
  }
`


const Column = ({column}) => {
  const {id, region_id, x_coord} = column
  return (
    <div>
      <b>{id}</b> {region_id} ({x_coord}).
    </div> 
  )
}

const Columns = () => (
  <Query query={GET_COLUMNS}>
    {({loading, error, data}) => {
      if (loading) return 'Loading...'
      if (error) return `Error! ${error.message}`
      return (
        <div>
          {data.htm_column.map(column => (
            <Column column={column} />
          ))}
        </div>
      )
    }}
  </Query>
)

const SpatialPooler = () => (
  <div>
    <h1>Spatial Pooler</h1>
    <Columns />
  </div>
)

const Home = () => (<h1>HTM</h1>)
const Region = () => (<h1>Region</h1>)


const App = () => (
  <BrowserRouter>
    <div className="App">
      <header className="App-header">
        <Switch>
          <Route path="/" component={Home} exact={true} />
          <Route path="/region" component={Region} exact={true} />
          <Route path="/spatialpooler" component={SpatialPooler} exact={true} />
          <Redirect to="/" />
        </Switch>
      </header>
    </div>
  </BrowserRouter>
)

export default App


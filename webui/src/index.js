import ApolloClient from 'apollo-boost'
import {ApolloProvider} from 'react-apollo'
import React from 'react'
import ReactDOM from 'react-dom'

import App from './App'
import * as serviceWorker from './serviceWorker'
import './index.css'


const graphqlClient = new ApolloClient({
  uri: 'http://localhost:8080/v1alpha1/graphql'
})


ReactDOM.render(
  <ApolloProvider client={graphqlClient}>
    <App />
  </ApolloProvider>,
  document.getElementById('root'),
)

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: http://bit.ly/CRA-PWA
serviceWorker.unregister()


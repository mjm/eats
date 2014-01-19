`/** @jsx React.DOM */`
React = require 'react'

NavBar = React.createClass
  render: ->
    `<nav className="navbar navbar-default" role="navigation">
      <div className="navbar-header">
        <a className="navbar-brand" href="/">
          <span className="glyphicon glyphicon-cutlery" />
          Eats
        </a>
      </div>
    </nav>`

module.exports = NavBar

`/** @jsx React.DOM */`
React = require 'react'

NavBar = React.createClass
  render: ->
    `<nav className="navbar navbar-default" role="navigation">
      <div className="navbar-header">
        <a className="navbar-brand" href="/">Eats</a>
      </div>
    </nav>`

module.exports = NavBar

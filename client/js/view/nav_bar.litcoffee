# NavBar

This component allows navigating between parts of the application.  Right now,
there are not multiple parts, so it's simply for appearances.

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

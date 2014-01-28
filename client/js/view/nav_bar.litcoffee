# NavBar

This component allows navigating between parts of the application.  Right now,
there are not multiple parts, so it's simply for appearances.

    `/** @jsx React.DOM */`
    React = require 'react'

    NavBar = React.createClass
      render: ->
        `<nav className="navbar navbar-default" role="navigation">
          {this.renderHeader()}
          <div className="navbar-collapse collapse" id="eats-navbar">
            {this.renderLinks()}
          </div>
        </nav>`

The header just displays an application name.

      renderHeader: ->
        `<div className="navbar-header">
          <button type="button" className="navbar-toggle" data-toggle="collapse" data-target="#eats-navbar">
            <span className="sr-only">Toggle navigation</span>
            <span className="icon-bar"></span>
            <span className="icon-bar"></span>
            <span className="icon-bar"></span>
          </button>
          <a className="navbar-brand" href="/">
            <span className="glyphicon glyphicon-cutlery" />
            Eats
          </a>
        </div>`

We display a list of links to switch between the different top-level views of
the application. The current one is passed in as a property, and we display
that one as active.

      renderLinks: ->
        `<ul className="nav navbar-nav">
          {this.renderLink('recipes', 'Recipes')}
          {this.renderLink('plans', 'Plans')}
        </ul>`

      renderLink: (view, name) ->
        if @props.view is view
          `<li className="active"><a href="javascript:;">{name}</a></li>`
        else
          `<li><a href={'#' + view}>{name}</a></li>`

    module.exports = NavBar

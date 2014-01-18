`/** @jsx React.DOM */`

React = require 'react'

key = require '../../util/key'

exports.View = React.createClass
  render: ->
    `<h1 className="panel-title recipe-name" onClick={this.props.onClick}>{this.props.name}</h1>`

exports.Edit = React.createClass
  getInitialState: ->
    newName: @props.name

  handleChange: (e) ->
    @setState newName: e.target.value

  handleSubmit: (e) ->
    e.preventDefault()
    @props.onSave(@state.newName)

  handleKeyDown: (e) ->
    if e.keyCode is key.ESC
      e.preventDefault()
      @props.onSave(@props.name)

  render: ->
    `<form onSubmit={this.handleSubmit}>
      <input
        className="form-control"
        type="text"
        onChange={this.handleChange}
        onKeyDown={this.handleKeyDown}
        value={this.state.newName}
        autoFocus />
    </form>`

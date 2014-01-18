`/** @jsx React.DOM */`

React = require 'react'

Controls = React.createClass
  render: ->
    `<div className="pull-right">
      <button type="button" className="btn btn-link" onClick={this.handleDelete}>Delete</button>
    </div>`

  handleDelete: ->
    @props.onDelete() if confirm('Are you sure you want to delete this recipe?')

module.exports = Controls

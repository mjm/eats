`/** @jsx React.DOM */`

React = require 'react'

EditKeys = require '../../common/edit_keys'

exports.View = React.createClass
  render: ->
    `<h1 className="panel-title recipe-name" onClick={this.props.onClick}>{this.props.name}</h1>`

exports.Edit = React.createClass
  mixins: [EditKeys]
  getInitialState: -> newName: @props.name

  render: ->
    `<form action="javascript:;" onSubmit={this.handleSubmit}>
      <input
        className="form-control"
        type="text"
        onChange={this.handleChange}
        onKeyDown={this.handleEditKeys}
        value={this.state.newName}
        autoFocus />
    </form>`

  handleSubmit: -> @props.onSave @state.newName
  handleCancel: -> @props.onSave @props.name

  handleChange: (e) -> @setState newName: e.target.value

# Plan Name Field

A plan's name is displayed as heading which when clicked converts into a large
text field.

    `/** @jsx React.DOM */`
    React = require 'react'
    EditKeys = require '../../common/edit_keys'

## View

    exports.View = React.createClass
      render: ->
        `<h3 onClick={this.props.onClick}>{this.props.name}</h3>`

## Edit

    exports.Edit = React.createClass

We use our standard [edit keys][ek] for this field.

[ek]: ../../common/edit_keys.litcoffee

      mixins: [EditKeys]

We start with the field populated with the last saved name.

      getInitialState: -> newName: @props.name

      render: ->
        `<form action="javascript:;" onSubmit={this.handleSubmit}>
          <input
            className="form-control input-lg"
            type="text"
            autoFocus
            onChange={this.handleChange}
            onKeyDown={this.handleEditKeys}
            value={this.state.newName} />
        </form>`

The handlers for typing, saving, and cancelling are trivial.

      handleSubmit: -> @props.onSave @state.newName
      handleCancel: -> @props.onSave @props.name
      handleChange: (e) -> @setState newName: e.target.value

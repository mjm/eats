# Recipe Name Field

This module provides view and edit controls for a recipe's name.

    `/** @jsx React.DOM */`
    React = require 'react'
    EditKeys = require '../../common/edit_keys'

## View

The name is displayed as a panel title. Clicking the name will switch to
editing mode.

    exports.View = React.createClass
      render: ->
        `<h1 className="panel-title recipe-name" onClick={this.props.onClick}>{this.props.name}</h1>`

## Edit

    exports.Edit = React.createClass

We use our common [`EditKeys`][editkeys] mixin to provide save and cancel
keyboard controls.

[editkeys]: ../../common/edit_keys.litcoffee

      mixins: [EditKeys]

We store the new name of the recipe in state so that the user has the option of
cancelling their changes. `@props.name` will always contain the last saved
name.

      getInitialState: -> newName: @props.name

Editing the name is done through a basic text field.

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

These handlers ensure that saving, cancelling, and typing all work as expected.

      handleSubmit: -> @props.onSave @state.newName
      handleCancel: -> @props.onSave @props.name
      handleChange: (e) -> @setState newName: e.target.value

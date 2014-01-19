# Recipe Instructions Field

This module provides the view and edit controls for the recipe's instructions.
Recipe instructions are represented as Markdown formatted text, which allows
more flexibility than a structured list of instructions.

    `/** @jsx React.DOM */`

    React  = require 'react'
    _      = require 'lodash'
    marked = require 'marked'

    EditKeys = require '../../common/edit_keys'

## View

    exports.View = View = React.createClass
      render: ->

If the instructions are empty, we need to show some text to click to switch
into edit mode. However, this view component is reused to provide a preview of
the rendered Markdown when editing, which should not have such a prompt.
Therefore, we provide a property to disable the prompt.

        if _.isEmpty(@props.instructions) and @props.showEmptyText isnt false
          `<div className="view" onClick={this.props.onClick}>Click to add instructions.</div>`

On the other hand, if the instructions are not empty or we're displaying a
preview, we convert the Markdown instructions to HTML and display them.

        else
          converted = marked @props.instructions or ''
          `<div
            className="view"
            dangerouslySetInnerHTML={{__html: converted}}
            onClick={this.props.onClick} />`

## Edit

    exports.Edit = React.createClass

The instructions editor uses the same [edit keys][editkeys] as the other editor
controls.

[editkeys]: ../../common/edit_keys.litcoffee

      mixins: [EditKeys]

We setup the state to initially have the current instructions.

      getInitialState: -> newInstructions: @props.instructions

The instructions editor is two columns: on the left is a textarea containing
the Markdown text, and on the right is a rendered preview of the text entered
on the left.

      render: ->
        `<div className="row edit">
          <div className="col-md-6">
            <form action="javascript:;" onSubmit={this.handleSubmit}>
              <textarea
                autoFocus
                rows="12"
                className="form-control"
                onKeyDown={this.handleEditKeys}
                onChange={this.handleChange}
                value={this.state.newInstructions} />
              <div className="buttons">
                <button type="submit" className="btn btn-primary btn-sm">Save</button>
                <button type="button" className="btn btn-link btn-sm" onClick={this.handleCancel}>Cancel</button>
              </div>
            </form>
          </div>
          <div className="col-md-6">
            <View instructions={this.state.newInstructions} showEmptyText={false} />
          </div>
        </div>`

The change, submit, and cancel handlers are trivial.

      handleSubmit: -> @props.onSave @state.newInstructions
      handleCancel: -> @props.onSave @props.instructions
      handleChange: (e) -> @setState newInstructions: e.target.value

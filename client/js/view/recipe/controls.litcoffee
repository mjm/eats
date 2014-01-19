# Controls

Controls displays a set of controls for manipulating a given recipe.
At the moment, the only option is deletion.

    `/** @jsx React.DOM */`

    React = require 'react'

    Controls = React.createClass

The controls are rendered as a series of buttons.

      render: ->
        `<div className="pull-right">
          <button type="button" className="btn btn-link" onClick={this.handleDelete}>
            <i className="fa fa-trash-o" />
            {' Delete'}
          </button>
        </div>`

Deleting a story requires a simple confirmation.

      handleDelete: ->
        @props.onDelete() if confirm 'Are you sure you want to delete this recipe?'

    module.exports = Controls

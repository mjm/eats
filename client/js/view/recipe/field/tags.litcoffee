# Recipe Tags Field

This module provides the view and edit controls for a recipe's tags.

    `/** @jsx React.DOM */`

    React = require 'react'
    _     = require 'lodash'

    key = require '../../../util/key'
    EditKeys = require '../../common/edit_keys'

## View

    exports.View = React.createClass

This component displays the list of tags. Clicking anywhere in the list
currently puts the tags in edit mode.

      render: ->
        `<div className="tags" onClick={this.props.onClick}>
          <i className="fa fa-tags" />{' '}
          {_.isEmpty(this.props.tags)
            ? <span>No tags.</span>
            : this.props.tags.map(this.renderTag)}
        </div>`

Each tag is rendered as a simple label.

      renderTag: (tag) ->
        `<span key={tag} className="label label-primary">{tag}</span>`

## Edit

    exports.Edit = React.createClass

We use our common [`EditKeys`][editkeys] mixin to provide save and cancel
keyboard controls.

[editkeys]: ../../common/edit_keys.litcoffee

      mixins: [EditKeys]

We store the new tags in state so that the user has the option of cancelling
their changes. `@props.tags` will always contain the last saved tags.

      getInitialState: -> newTags: @props.tags

At the moment, the tags editor is pretty basic. There is a text field with each
tag separated by a comma and a space. We could later turn this into a more
sophisticated editor.

      render: ->
        `<div className="tags">
          <form className="form-inline" action="javascript:;" onSubmit={this.handleSubmit}>
            <input
              type="text"
              className="form-control input-sm"
              onChange={this.handleChange}
              onKeyDown={this.handleKeyDown}
              autoFocus
              value={this.state.newTags.join(", ")} />
            <button type="submit" className="btn btn-primary btn-sm">Save</button>
            <button type="button" className="btn btn-link btn-sm" onClick={this.handleCancel}>Cancel</button>
          </form>
        </div>`

When we save the tags, we take out any empty tags as well as any duplicates.

      handleSubmit: -> @props.onSave _.uniq _.without @state.newTags, ''
      handleCancel: -> @props.onSave @props.tags

When the user enters text into the field, we have to update our collection of
tags by splitting the text in the field. Because React ensures the component
state and the text field are consistent, this has interesting implications on
how entering text in this field behaves.

For instance, entering a comma will actually enter a space as well because
that's how the tags are joined when rendering. Currently, this also trims
whitespace off the end of tags, which actually prevents entering spaces in the
middle of tags, since they'll be trimmed right away.

      handleChange: (e) ->
        @setState newTags: e.target.value.split(",").map (tag) -> tag.trim()

In addition to our standard editing keyboard shortcuts, we also have to add
special behavior for the backspace key. Since we split on commas but join with
comma-space, trying to backspace over the space before a comma will not change
the state, and therefore the space won't be deleted.

To resolve this, we make sure that backspacing with an empty final tag deletes
the tag, removing the comma and space together. This assumes the caret is at the
end of the field right now, which is a bit too presumptuous.

      handleKeyDown: (e) ->
        if e.keyCode is key.BACKSPACE and _.isEmpty _.last @state.newTags
          e.preventDefault()
          @setState newTags: @state.newTags[0..-2]
        else
          @handleEditKeys e

`/** @jsx React.DOM */`

React = require 'react'
_     = require 'lodash'

key = require '../../util/key'
EditKeys = require '../common/edit_keys'

exports.View = React.createClass
  renderTag: (tag) ->
    `<span className="label label-primary">{tag}</span>`

  render: ->
    `<div className="tags" onClick={this.props.onClick}>
      {_.isEmpty(this.props.tags)
        ? <span>No tags.</span>
        : this.props.tags.map(this.renderTag)}
    </div>`

exports.Edit = React.createClass
  mixins: [EditKeys]

  getInitialState: ->
    newTags: _.clone @props.tags

  render: ->
    `<div className="tags">
      <form className="form-inline" action="#" onSubmit={this.handleSubmit}>
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

  handleSubmit: (e) ->
    e.preventDefault()
    @props.onSave _.uniq _.without @state.newTags, ''

  handleChange: (e) ->
    @setState newTags: e.target.value.split(",").map (tag) -> tag.trim()

  handleKeyDown: (e) ->
    if e.keyCode is key.BACKSPACE and _.isEmpty _.last @state.newTags
      e.preventDefault()
      @setState newTags: @state.newTags[0..-2]
    else
      @handleEditKeys e

  handleCancel: ->
      @props.onSave @props.tags

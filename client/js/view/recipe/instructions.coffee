`/** @jsx React.DOM */`

React  = require 'react'
_      = require 'lodash'
marked = require 'marked'

EditKeys = require '../common/edit_keys'

exports.View = View = React.createClass
  render: ->
    if _.isEmpty(@props.instructions) and @props.showEmptyText isnt false
      `<div className="view" onClick={this.props.onClick}>Click to add instructions.</div>`
    else
      converted = marked @props.instructions or ''
      `<div className="view" dangerouslySetInnerHTML={{__html: converted}} onClick={this.props.onClick} />`

exports.Edit = React.createClass
  mixins: [EditKeys]

  getInitialState: ->
    newInstructions: @props.instructions

  render: ->
    `<div className="row edit">
      <div className="col-md-6">
        <form action="#" onSubmit={this.handleSubmit}>
          <textarea autoFocus rows="12" className="form-control" onKeyDown={this.handleEditKeys} onChange={this.handleChange} value={this.state.newInstructions} />
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

  handleSubmit: (e) ->
    e.preventDefault()
    @props.onSave @state.newInstructions

  handleCancel: ->
    @props.onSave @props.instructions

  handleChange: (e) ->
    @setState newInstructions: e.target.value

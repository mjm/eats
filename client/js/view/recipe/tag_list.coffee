`/** @jsx React.DOM */`

React = require 'react'

TagList = React.createClass
  renderTag: (tag) ->
    `<li>
      {tag === this.props.selectedTag
        ? tag || 'None'
        : <a href="javascript:;" onClick={this.handleSelect.bind(this, tag)}>{tag || 'None'}</a>}
    </li>`

  render: ->
    filters = [null].concat @props.tags
    `<ul className="list-inline">
      <li><strong>Filter:</strong></li>
      {filters.map(this.renderTag)}
    </ul>`

  handleSelect: (tag) ->
    @props.onSelect tag

module.exports = TagList

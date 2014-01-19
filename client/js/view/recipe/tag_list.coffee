`/** @jsx React.DOM */`

React = require 'react'
_     = require 'lodash'

TagList = React.createClass
  renderTag: (tag) ->
    display = tag or 'None'
    `<li key={display}>
      {tag === this.props.selectedTag
        ? display
        : <a href="javascript:;" onClick={_.partial(this.props.onSelect, tag)}>{display}</a>}
    </li>`

  render: ->
    filters = [null].concat @props.tags
    `<ul className="list-inline">
      <li><strong>Filter:</strong></li>
      {filters.map(this.renderTag)}
    </ul>`

module.exports = TagList

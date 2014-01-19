# TagList

TagList provides the options for filtering the list of recipes to those with a
particular tag.

    `/** @jsx React.DOM */`

    React = require 'react'
    _     = require 'lodash'

    TagList = React.createClass

The list of tags is rendered as a list. We include an option for each tag, as well as
a 'None' option to allow showing all recipes.

      render: ->
        filters = [null].concat @props.tags
        `<ul className="list-inline">
          <li><strong>Filter:</strong></li>
          {filters.map(this.renderTag)}
        </ul>`

Each tag option is a list item. If the tag is not selected, it's rendered as a link
to select the tag. If the tag is already selected, it's simply shown as text.

      renderTag: (tag) ->
        display = tag or 'None'
        `<li key={display}>
          {tag === this.props.selectedTag
            ? display
            : <a href="javascript:;" onClick={_.partial(this.props.onSelect, tag)}>{display}</a>}
        </li>`

    module.exports = TagList

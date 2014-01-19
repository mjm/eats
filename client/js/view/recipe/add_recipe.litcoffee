# AddRecipe

AddRecipe simply provides a button to add a new recipe.

    `/** @jsx React.DOM */`

    React = require 'react'

    AddRecipe = React.createClass
      render: ->
        `<p>
          <button type="button" className="btn btn-success btn-block" onClick={this.props.onAdd}>
            <span className="glyphicon glyphicon-plus-sign" /> Recipe
          </button>
        </p>`

    module.exports = AddRecipe

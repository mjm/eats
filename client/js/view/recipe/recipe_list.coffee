`/** @jsx React.DOM */`

React = require 'react/addons'
{classSet} = React.addons

RecipeList = React.createClass
  recipeClasses: (recipe) ->
    classSet
      'list-group-item': true
      active: recipe.id is @props.selectedRecipe?.id

  renderRecipe: (recipe) ->
    handleSelect = @handleSelectRecipe.bind @, recipe
    `<a
      href="javascript:;"
      onClick={handleSelect}
      key={recipe.id}
      className={this.recipeClasses(recipe)}>
        {recipe.get('name')}
    </a>`

  render: ->
    `<div className="list-group">
      {this.props.recipes.map(this.renderRecipe)}
    </div>`

  handleSelectRecipe: (recipe) ->
    @props.onSelectRecipe recipe

module.exports = RecipeList

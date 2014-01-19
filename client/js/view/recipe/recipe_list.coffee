`/** @jsx React.DOM */`

React = require 'react/addons'
_     = require 'lodash'
{classSet} = React.addons

RecipeList = React.createClass
  recipeClasses: (recipe) ->
    classSet
      'list-group-item': true
      active: recipe.id is @props.selectedRecipe?.id

  renderRecipe: (recipe) ->
    `<a
      href="javascript:;"
      onClick={_.partial(this.props.onSelectRecipe, recipe)}
      key={recipe.id}
      className={this.recipeClasses(recipe)}>
        <i className="fa fa-book" />
        {' ' + recipe.get('name')}
    </a>`

  render: ->
    `<div className="list-group">
      {this.props.recipes.map(this.renderRecipe)}
    </div>`

module.exports = RecipeList

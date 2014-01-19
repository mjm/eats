# RecipeList

RecipeList is a simple linked list of recipes.

    `/** @jsx React.DOM */`

    React = require 'react/addons'
    _     = require 'lodash'
    {classSet} = React.addons

    RecipeList = React.createClass

If a recipe is selected, give it the `active` class.

      recipeClasses: (recipe) ->
        classSet
          'list-group-item': true
          active: recipe.id is @props.selectedRecipe?.id

We list each recipe as a linked list item in a list group. When the user clicks
the link, we call the `onSelectRecipe` callback with the recipe they selected.

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

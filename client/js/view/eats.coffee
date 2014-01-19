`/** @jsx React.DOM */`

require './eats.less'

Backbone = require 'backbone'
React    = require 'react'
_        = require 'lodash'

{Recipe, Recipes} = require '../model/recipe'

NavBar      = require './nav_bar'
Router      = require './recipe/router'
RecipeIndex = require './recipe/index'

Eats = React.createClass
  getInitialState: ->
    router: new Router
    recipes: new Recipes
    selectedRecipe: null
    selectedTag: null

  componentDidMount: ->
    @state.recipes.fetch().then =>
      @state.router.on 'route:viewRecipe', (id) =>
        @setState selectedRecipe: @state.recipes.get id
      @state.router.on 'route:viewTagRecipes', (tag) =>
        @setState selectedTag: tag
      @state.router.on 'route:viewTagRecipe', (tag, id) =>
        @setState
          selectedTag: tag
          selectedRecipe: @state.recipes.get id

      @forceUpdate()
      Backbone.history.start()

  render: ->
    `<div>
      <NavBar />
      <div id="container">
        <RecipeIndex
          recipes={this.state.recipes}
          selectedRecipe={this.state.selectedRecipe}
          selectedTag={this.state.selectedTag}
          onSelectTag={this.handleSelectTag}
          onSelectRecipe={this.handleSelectRecipe}
          onAddRecipe={this.handleSelectRecipe}
          onUpdateRecipe={this.handleSelectRecipe}
          onDeleteRecipe={_.partial(this.handleSelectRecipe, null)} />
      </div>
    </div>`

  handleSelectTag: (tag) -> @setState selectedTag: tag, @navigate
  handleSelectRecipe: (recipe) -> @setState selectedRecipe: recipe, @navigate

  navigate: ->
    {selectedTag: tag, selectedRecipe: recipe} = @state
    url = _.compact([
      tag and "tag/#{tag}",
      'recipes',
      recipe and "#{recipe.id}"
    ]).join '/'

    @state.router.navigate url

module.exports = Eats

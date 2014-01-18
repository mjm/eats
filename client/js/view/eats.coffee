`/** @jsx React.DOM */`

require './eats.less'

Backbone = require 'backbone'
React    = require 'react'
_        = require 'lodash'

{Recipe, Recipes} = require '../model/recipe'

NavBar     = require './nav_bar'
Router     = require './recipe/router'
AddRecipe  = require './recipe/add_recipe'
TagList    = require './recipe/tag_list'
RecipeList = require './recipe/recipe_list'
ViewRecipe = require './recipe/view_recipe'

Eats = React.createClass
  getInitialState: ->
    router: new Router
    recipes: new Recipes
    selectedRecipe: null
    selectedTag: null

  componentDidMount: ->
    @state.recipes.fetch().then =>
      @forceUpdate()

      @state.router.on 'route:viewRecipe', (id) =>
        @setState selectedRecipe: @state.recipes.get id

      @state.router.on 'route:viewTagRecipes', (tag) =>
        @setState selectedTag: tag

      @state.router.on 'route:viewTagRecipe', (tag, id) =>
        @setState
          selectedTag: tag
          selectedRecipe: @state.recipes.get id

      Backbone.history.start()

  render: ->
    if @state.selectedTag
      filteredRecipes = @state.recipes.filter (recipe) =>
        _.contains recipe.get('tags'), @state.selectedTag
    else
      filteredRecipes = @state.recipes

    `<div>
      <NavBar />
      <div id="container">
        <div className="row">
          <div className="col-md-3">
            <AddRecipe onAdd={this.handleAddRecipe} />
            <TagList
              tags={this.state.recipes.tags()}
              selectedTag={this.state.selectedTag}
              onSelect={this.handleSelectTag} />
            <RecipeList
              recipes={filteredRecipes}
              selectedRecipe={this.state.selectedRecipe}
              onSelectRecipe={this.handleSelectRecipe} />
          </div>
          {this.state.selectedRecipe
            ? <ViewRecipe
                recipe={this.state.selectedRecipe}
                onUpdate={this.handleUpdateRecipe}
                onDelete={this.handleDeleteRecipe} />
            : 'No recipe selected'}
        </div>
      </div>
    </div>`

  handleSelectTag: (tag) ->
    @setState selectedTag: tag
    @navigate tag, @state.selectedRecipe

  handleSelectRecipe: (recipe) ->
    @setState selectedRecipe: recipe
    @navigate @state.selectedTag, recipe

  handleUpdateRecipe: (recipe) ->
    recipe.save()
    @forceUpdate()

  handleAddRecipe: ->
    @handleSelectRecipe @state.recipes.create tags: _.compact [@state.selectedTag]

  handleDeleteRecipe: (recipe) ->
    recipe.destroy()
    @handleSelectRecipe null

  navigate: (tag, recipe) ->
    url = _.compact([
      tag and "tag/#{tag}",
      'recipes',
      recipe and "#{recipe.id}"
    ]).join '/'

    @state.router.navigate url

module.exports = Eats

# Eats: Top-Level React Component

The top-level component is mainly responsible for setting up the overall
structure of view. This include the navigation bar and whatever content view is
appropriate given the state of the application.

The Eats component also holds global state of the application. It uses a Backbone
router to keep this state in sync with the current URL.

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

To setup the application fresh, we create the router and an empty recipes
collection. Unless set later by the router, we also begin with no selected
recipe or tag filter.

      getInitialState: ->
        router: new Router
        recipes: new Recipes
        selectedRecipe: null
        selectedTag: null

When the component loads, we fetch the recipes collection. This should only
happen once: when the application is first loaded.

      componentDidMount: ->
        @state.recipes.fetch().then =>

When the recipes are loaded, we set up the routing handlers, re-render the
view, and start listening for browser history events.

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

The top-level component renders the navigation bar that appears at the top of the
window as well as the main recipes content view.

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

We provide handlers for updating the selection state. Even though the
selections are only relevant to the recipes view, we maintain them here since
they are driven by the URL. If we maintained them on the recipes view, that
view may not exist when the relevant routing events were fired.

      handleSelectTag: (tag) -> @setState selectedTag: tag, @navigate
      handleSelectRecipe: (recipe) -> @setState selectedRecipe: recipe, @navigate

`navigate` is intended to be used as a callback after updating this component's
state. It tells the router to make the URL consistent with the current state of
the application.

      navigate: ->
        {selectedTag: tag, selectedRecipe: recipe} = @state
        url = _.compact([
          tag and "tag/#{tag}",
          'recipes',
          recipe and "#{recipe.id}"
        ]).join '/'

        @state.router.navigate url

    module.exports = Eats

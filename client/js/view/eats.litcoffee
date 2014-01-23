# Eats: Top-Level React Component

The top-level component is mainly responsible for setting up the overall
structure of view. This includes the [navigation bar][navbar] and whatever
content view is appropriate given the state of the application.

The Eats component also holds global state of the application. It uses a Backbone
router to keep this state in sync with the current URL.

[navbar]: nav_bar.litcoffee

    `/** @jsx React.DOM */`

    require './eats.less'

    Backbone = require 'backbone'
    React    = require 'react'
    _        = require 'lodash'

    {Recipe, Recipes} = require '../model/recipe'

    NavBar       = require './nav_bar'
    Router       = require './router'

    RecipeIndex  = require './recipe/index'
    PlanIndex    = require './plan/index'

    Eats = React.createClass

To setup the application fresh, we create the [router][] and an empty
[`Recipes`][recipes] collection. Unless set later by the router, we also begin
with no selected recipe or tag filter.

The current view is determined by the `view` state property. By default, we are
in the recipes view.

[router]: recipe/router.litcoffee
[recipes]: ../model/recipe.litcoffee

      getInitialState: ->
        router: new Router
        recipes: new Recipes
        view: 'recipes'
        selectedRecipe: null
        selectedTag: null

When the component loads, we fetch the recipes collection. This should only
happen once: when the application is first loaded.

      componentDidMount: ->
        @state.recipes.fetch().then =>

When the recipes are loaded, we set up the routing handlers, re-render the
view, and start listening for browser history events.

          @setupRecipeRoutes @state.router
          @setupPlanRoutes @state.router

          @forceUpdate()
          Backbone.history.start()

      setupRecipeRoutes: (router) ->
        router.on 'route:recipes', =>
          @setState view: 'recipes'
        router.on 'route:viewRecipe', (id) =>
          @setState view: 'recipes', selectedRecipe: @state.recipes.get id
        router.on 'route:viewTagRecipes', (tag) =>
          @setState view: 'recipes', selectedTag: tag
        router.on 'route:viewTagRecipe', (tag, id) =>
          @setState
            view: 'recipes'
            selectedTag: tag
            selectedRecipe: @state.recipes.get id

      setupPlanRoutes: (router) ->
        router.on 'route:plans', => @setState view: 'plans'

The top-level component renders the navigation bar that appears at the top of
the window as well as the main content view, which is either [recipes][rindex]
or [plans][pindex].

[rindex]: recipe/index.litcoffee
[pindex]: plan/index.litcoffee

      render: ->
        `<div>
          <NavBar view={this.state.view} />
          <div id="container">
            {this.state.view === 'recipes' &&
              <RecipeIndex
                recipes={this.state.recipes}
                selectedRecipe={this.state.selectedRecipe}
                selectedTag={this.state.selectedTag}
                onSelectTag={this.handleSelectTag}
                onSelectRecipe={this.handleSelectRecipe}
                onAddRecipe={this.handleSelectRecipe}
                onUpdateRecipe={this.handleSelectRecipe}
                onDeleteRecipe={_.partial(this.handleSelectRecipe, null)} />}
            {this.state.view === 'plans' &&
              <PlanIndex recipes={this.state.recipes} />}
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

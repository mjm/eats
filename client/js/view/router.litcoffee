# Router

This router provides URL mappings for the application.  The router produces
events for URL changes, which the [`Eats`][eats] component listens for and acts
upon.

[eats]: ../eats.litcoffee

    Backbone = require 'backbone'

    class Router extends Backbone.Router
      routes:
        'recipes': 'recipes'
        'recipes/:id': 'viewRecipe'
        'tag/:tag/recipes': 'viewTagRecipes'
        'tag/:tag/recipes/:id': 'viewTagRecipe'
        'plans': 'plans'

    module.exports = Router

# Router: URLs for Recipes

This router provides URL mappings for the recipes portion of the application.

    Backbone = require 'backbone'

    class Router extends Backbone.Router
      routes:
        'recipes/:id': 'viewRecipe'
        'tag/:tag/recipes': 'viewTagRecipes'
        'tag/:tag/recipes/:id': 'viewTagRecipe'

    module.exports = Router

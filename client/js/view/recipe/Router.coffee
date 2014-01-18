Backbone = require 'backbone'

class Router extends Backbone.Router
  routes:
    'recipes/:id': 'viewRecipe'
    'tag/:tag/recipes': 'viewTagRecipes'
    'tag/:tag/recipes/:id': 'viewTagRecipe'

module.exports = Router

Backbone = require 'backbone'
Backbone.$ = $
Backbone.LocalStorage = require 'backbone.localstorage'
_ = require 'lodash'

class exports.Recipe extends Backbone.Model
  defaults:
    name: 'Unnamed Recipe'
    ingredients: []
    tags: []

class exports.Recipes extends Backbone.Collection
  localStorage: new Backbone.LocalStorage('eats-recipes')
  model: exports.Recipe

  tags: ->
    _.uniq(_.sortBy(_.flatten(@pluck('tags'))))

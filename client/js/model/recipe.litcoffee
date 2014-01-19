# Recipe

A Backbone model and collection for the recipes the application manages.  Right
now, the application has no backend, so we use HTML5 local storage to store the
recipes.

    Backbone = require 'backbone'
    Backbone.$ = $
    Backbone.LocalStorage = require 'backbone.localstorage'
    _ = require 'lodash'

## Model: `Recipe`

The Recipe model is very simple. We simply specify a few default attributes.

    class exports.Recipe extends Backbone.Model
      defaults:
        name: 'Unnamed Recipe'
        ingredients: []
        tags: []

## Collection: `Recipes`

The Recipes collection stores the recipes in it under the `eats-recipes`
localStorage key.

    class exports.Recipes extends Backbone.Collection
      localStorage: new Backbone.LocalStorage 'eats-recipes'
      model: exports.Recipe

Tags are simple strings in our application, not full-fledged models. We need a
way to display a list of all available tags, so we collect all the unique tags
from every recipe. This is probably rather inefficient if there are many
recipes or tags, and so it's probably not a good long-term solution.

      tags: ->
        _.uniq _.sortBy _.flatten @pluck 'tags'

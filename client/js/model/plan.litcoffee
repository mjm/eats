# Plan

A Backbone model and collection for meal plans.

    Backbone = require 'backbone'
    Backbone.$ = $
    Backbone.LocalStorage = require 'backbone.localstorage'

## Model: `Plan`

A meal plan has a descriptive name, a set number of days, and a collection of
meals for each day.

    class exports.Plan extends Backbone.Model
      defaults:
        name: 'Unnamed Plan'
        dayCount: 7
        meals: []

## Collection: `Plans`

Plans are stored in HTML5 Local Storage under the `eats-plans` key.

    class exports.Plans extends Backbone.Collection
      localStorage: new Backbone.LocalStorage 'eats-plans'
      model: exports.Plan

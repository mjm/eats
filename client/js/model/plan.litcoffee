# Plan

A Backbone model and collection for meal plans.

    Backbone = require 'backbone'
    Backbone.$ = $
    Backbone.LocalStorage = require 'backbone.localstorage'

## Model: `Plan`

A meal plan has a descriptive name as well as an ordered collection of days,
each consisting of a collection of meals.

    class exports.Plan extends Backbone.Model
      defaults:
        name: 'Unnamed Plan'
        meals: [1..7].map -> []

## Collection: `Plans`

Plans are stored in HTML5 Local Storage under the `eats-plans` key.

    class exports.Plans extends Backbone.Collection
      localStorage: new Backbone.LocalStorage 'eats-plans'
      model: exports.Plan

## Functions

The collection of meals for each day is treated as immutable. We provide some
functions around the common operations for this list, all of which create a new
version of the list and leave the original intact.

    _ = require 'lodash'

First, we can add a recipe to the list.

    exports.addRecipe = (meals, index, recipe) ->
      _.tap _.clone(meals), (newMeals) ->
        newMeals[index] = newMeals[index].concat recipe.id

We can also remove a specific recipe from the list. There is no specific way to
identify it other than the day index and meal index.

    exports.removeRecipe = (meals, dayIndex, index) ->
      _.tap _.clone(meals), (newMeals) ->
        newMeals[dayIndex] = _.reject newMeals[dayIndex], (_, i) -> i is index

We can add a new day to the list. This will add an empty list of meals at the
appropriate position.

    exports.addDay = (meals, index) ->
      _.tap _.clone(meals), (newMeals) ->
        newMeals.splice index, 0, []

We can remove an entire day from the list. This will shorten the number of
days, and all meals scheduled for that day will be removed from the plan.

    exports.removeDay = (meals, index) ->
      _.reject meals, (_, i) -> i is index

# Meals Plan Field

This component allows the user to add meals to a plan.

    `/** @jsx React.DOM */`
    React = require 'react'
    _     = require 'lodash'

## Day Panel

`DayPanel` is a common component between the view and edit components.
It provides the frame for displaying a panel for a day's meals. The contents
are different based on the mode, but the frame remains the same.

    DayPanel = React.createClass
      render: ->
        `<div className="col-md-2">
          <div className="panel panel-default">
            <div className="panel-heading">
              Day {this.props.index + 1}
            </div>
            <div className="panel-body">
              {this.props.children}
            </div>
          </div>
        </div>`

## Recipes Modal

When the user wants to add a meal to a day in the plan, we present a modal dialog
to allow them to choose which recipe to add.

    RecipeModal = React.createClass
      render: ->
        `<div className="modal fade">
          <div className="modal-dialog">
            <div className="modal-content">
              <div className="modal-header">
                <h4 className="modal-title">Add a Recipe</h4>
              </div>
              <div className="modal-body">
                Hello!
              </div>
            </div>
          </div>
        </div>`

      show: ->
        $(@getDOMNode()).modal 'show'

## View

    exports.View = React.createClass

We render a panel for each day. We make sure to handle clicks so we can switch
into edit mode.

      render: ->
        `<div className="row" onClick={this.props.onClick}>
          {this.props.meals.map(this.renderDay)}
        </div>`

Each day shows a list of the meals planned for that day.

      renderDay: (meals, index) ->
        `<DayPanel index={index}>
          {_.isEmpty(meals)
            ? <p>No meals.</p>
            : meals.map(this.renderRecipe)}
        </DayPanel>`

      renderRecipe: (recipeId) ->
        recipe = @props.recipes.get recipeId
        `<p>{recipe.get('name')}</p>`

## Edit

    exports.Edit = React.createClass

Initially, our draft version of the meals is the same as the last saved meals.

      getInitialState: -> newMeals: @props.meals

Similar to the view component, we render a panel for each day. However, the
panels now include ways to add or remove meals from the days.

      render: ->
        `<div className="row">
          {this.state.newMeals.map(this.renderDay)}
        </div>`

      renderDay: (meals, index) ->
        `<DayPanel index={index}>
          {_.isEmpty(meals)
            ? <p>No meals.</p>
            : meals.map(this.renderRecipe)}
          <button
            className="btn btn-primary"
            onClick={this.handleAddMeal.bind(this, index)}>
            Add Meal
          </button>
          <RecipeModal ref={'modal'+index} />
        </DayPanel>`

      renderRecipe: (recipeId) ->
        recipe = @props.recipes.get recipeId
        `<p>{recipe.get('name')}</p>`

When the user clicks the "Add Meal" button for a day, we show them a list of
recipes to add. Temporarily, we're just adding the first recipe.

      handleAddMeal: (index) ->
        #recipe = @props.recipes.first() # TODO prompt from user
        #@setState newMeals: _.tap _.clone(@state.newMeals), (meals) ->
        #  meals[index] = meals[index].concat recipe.id
        @refs["modal#{index}"].show()


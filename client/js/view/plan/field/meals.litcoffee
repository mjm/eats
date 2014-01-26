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

    RecipeList = require '../../recipe/recipe_list'

    RecipeModal = React.createClass
      render: ->
        `<div className="modal fade">
          <div className="modal-dialog">
            <div className="modal-content">
              <div className="modal-header">
                <h4 className="modal-title">Add a Recipe</h4>
              </div>
              <div className="modal-body">
                <RecipeList
                  recipes={this.props.recipes}
                  onSelectRecipe={this.handleSelect} />
              </div>
            </div>
          </div>
        </div>`

We expose methods for showing and hiding the dialog.

      show: -> $(@getDOMNode()).modal 'show'
      hide: -> $(@getDOMNode()).modal 'hide'

When the user selects a recipe, we tell our parent component and close the
dialog.

      handleSelect: (recipe) ->
        @props.onSelect recipe
        @hide()

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

    plan = require '../../../model/plan'

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
            : meals.map(this.renderRecipe.bind(this, index))}
          <button
            className="btn btn-primary"
            onClick={this.handleAddMeal.bind(this, index)}>
            Add Meal
          </button>
          <RecipeModal
            ref={'modal'+index}
            recipes={this.props.recipes}
            onSelect={this.handleSelectMeal.bind(this, index)} />
        </DayPanel>`

      renderRecipe: (mealsIndex, recipeId, index) ->
        recipe = @props.recipes.get recipeId
        `<p>
          {recipe.get('name')}
          <button className="btn btn-link" onClick={this.handleDeleteMeal.bind(this, mealsIndex, index)}>
            <i className="fa fa-trash-o" />
          </button>
        </p>`

When the user clicks the "Add Meal" button for a day, we show them a list of
recipes to add. The dialog is already rendered, so we just need to show it.

      handleAddMeal: (index) -> @refs["modal#{index}"].show()

When the user selects a recipe from the dialog, we add it to the end of the
list of meals for that day.

      handleSelectMeal: (index, recipe) ->
        @setState newMeals: plan.addRecipe(@state.newMeals, index, recipe), =>
          @props.onSave @state.newMeals

When user deletes a recipe, we remove it from the meals collection for that
day.

      handleDeleteMeal: (mealsIndex, index) ->
        @setState newMeals: plan.removeRecipe(@state.newMeals, mealsIndex, index), =>
          @props.onSave @state.newMeals

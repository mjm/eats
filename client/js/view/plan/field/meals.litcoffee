# Meals Plan Field

This component allows the user to add meals to a plan.

    `/** @jsx React.DOM */`
    React = require 'react'
    _     = require 'lodash'

    require './meals.less'

## Day Panel

`DayPanel` is a common component between the view and edit components.
It provides the frame for displaying a panel for a day's meals. The contents
are different based on the mode, but the frame remains the same.

    DayPanel = React.createClass
      render: ->
        `<div className="col-md-2">
          <div className="panel panel-default">
            <div className="panel-heading">
              <i className="fa fa-calendar" />
              {' Day ' + (this.props.index + 1)}
              {this.props.onDelete &&
                <button className="btn btn-xs btn-danger pull-right" onClick={this.props.onDelete}>
                  <i className="fa fa-trash-o" />
                </button>}
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

## Rows of Content

To display the day panels properly in rows, we need to able to partition them
into rows of a certain size.

    rowsOf = (items, columns) ->
      _.toArray _.groupBy items, (_, i) -> Math.floor(i / 6)

## View

    exports.View = React.createClass

We render a panel for each day. We make sure to handle clicks so we can switch
into edit mode.

      render: ->
        `<div onClick={this.props.onClick}>
          {_.isEmpty(this.props.meals)
            ? <p>No days in this plan.</p>
            : rowsOf(this.props.meals, 6).map(this.renderRow)}
        </div>`

      renderRow: (days) ->
        `<div className="row">
          {days.map(this.renderDay)}
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
        panelRows = rowsOf @state.newMeals, 6
        `<div className="panel panel-success meals-edit">
          <div className="panel-heading">
            {this.renderButtons()}
            <h4 className="panel-title clearfix">
              <i className="fa fa-pencil" />
              {' Editing meals'}
            </h4>
          </div>
          <div className="panel-body">
            {panelRows.map(this.renderRow)}
          </div>
          <div className="panel-footer">
            {this.renderButtons()}
            <div className="clearfix"/>
          </div>
        </div>`

      renderButtons: ->
        `<div className="btn-group pull-right">
          <button className="btn btn-default" onClick={this.handleAddDay.bind(this, this.state.newMeals.length)}>
            <i className="fa fa-plus" />{' Add Day'}
          </button>
          <button className="btn btn-success" onClick={this.props.onDone}>
            <i className="fa fa-check" />{' Done'}
          </button>
        </div>`

      renderRow: (days, index) ->
        panels = days.map (meals, i) => @renderDay meals, (index * 6) + i
        `<div className="row">{panels}</div>`

Each day is shown as a day panel, just like when viewing the meals. However,
editing offers several more options, including deleting the day, adding meals,
and a pre-rendered modal dialog for selecting new meals which remains invisible
until clicking the "Add Meal" button.

      renderDay: (meals, index) ->
        `<DayPanel index={index} onDelete={this.handleDeleteDay.bind(this, index)}>
          {_.isEmpty(meals)
            ? <p>No meals.</p>
            : meals.map(this.renderRecipe.bind(this, index))}
          <button
            className="btn btn-sm btn-primary"
            onClick={this.handleAddMeal.bind(this, index)}>
            <i className="fa fa-plus" />{' Add Meal'}
          </button>
          <RecipeModal
            ref={'modal'+index}
            recipes={this.props.recipes}
            onSelect={this.handleSelectMeal.bind(this, index)} />
        </DayPanel>`

Recipes are displayed with the name of the meal, as well as a link to remove
that meal from the plan.

      renderRecipe: (mealsIndex, recipeId, index) ->
        recipe = @props.recipes.get recipeId
        `<p>
          {recipe.get('name')}
          <button className="btn btn-link" onClick={this.handleDeleteMeal.bind(this, mealsIndex, index)}>
            <i className="fa fa-trash-o" />
          </button>
        </p>`

Our handlers need a convenient way to update the new state of the meals.
Every time we change the meals, we save them as well.

      updateMeals: (newMeals) ->
        @setState newMeals: newMeals, =>
          @props.onSave @state.newMeals

When the user clicks the "Add Meal" button for a day, we show them a list of
recipes to add. The dialog is already rendered, so we just need to show it.

      handleAddMeal: (index) -> @refs["modal#{index}"].show()

When the user selects a recipe from the dialog, we add it to the end of the
list of meals for that day.

      handleSelectMeal: (index, recipe) ->
        @updateMeals plan.addRecipe @state.newMeals, index, recipe

When user deletes a recipe, we remove it from the meals collection for that
day.

      handleDeleteMeal: (mealsIndex, index) ->
        @updateMeals plan.removeRecipe @state.newMeals, mealsIndex, index

When the user adds a day, we add an empty meals list at the right place in the
meals collection.

      handleAddDay: (index) ->
        @updateMeals plan.addDay @state.newMeals, index

When the user deletes a day, remove it from the meals collection.

      handleDeleteDay: (index) ->
        @updateMeals plan.removeDay @state.newMeals, index

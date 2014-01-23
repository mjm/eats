# ViewPlan: Plan Viewer and Editor

The ViewPlan component allows the user to view an individual plan, edit its
details, and plan the meals on the plan.

    `/** @jsx React.DOM */`
    React = require 'react'
    _     = require 'lodash'
    {View: ViewName,  Edit: EditName}   = require './field/name'
    {View: ViewMeals, Edit: EditMeals} = require './field/meals'

    ViewPlan = React.createClass

Initially we are not editing any part of the plan.

      getInitialState: -> editing: null

      render: ->
        editing = @state.editing
        `<div>
          {this.renderName(this.props.plan.get('name'), editing === 'name')}
          {this.renderMeals(this.props.plan.get('meals'), editing === 'meals')}
        </div>`

The name is shown across the top, and we show the correct view or edit
component based on the editing state.

      renderName: (name, editing) ->
        `<div className="row">
          <div className="col-md-12">
            {editing
              ? <EditName name={name} onSave={this.saveHandler('name')} />
              : <ViewName name={name} onClick={this.editHandler('name')} />}
          </div>
        </div>`

The meals are shown as a row of panels, one for each day in the plan.

      renderMeals: (meals, editing) ->
        options = meals: meals, recipes: @props.recipes
        if editing
          EditMeals options
        else
          ViewMeals _.extend options,
            onClick: @editHandler 'meals'

We provide convenience functions for handlers that switch between viewing and
editing.

      editHandler: (field) ->
        => @setState editing: field

      saveHandler: (field) ->
        (value) =>
          @props.plan.set field, value
          @props.onUpdate @props.plan
          @setState editing: null

    module.exports = ViewPlan

# Index: Main Plans Component

The plans Index view manages the part of the application that allows arranging
recipes into meal plans.

    `/** @jsx React.DOM */`
    React = require 'react'
    {Plan, Plans} = require '../../model/plan'
    PlanList = require './plan_list'
    ViewPlan = require './view_plan'

    Index = React.createClass

The meal plans screen consists of two main components. At the top of the screen
is a horizontal [list of plans][plist] that the user has made. Below that is a
display of the [currently selected plan][viewplan].

[plist]: plan_list.litcoffee
[viewplan]: view_plan.litcoffee

      render: ->
        `<div>
          {this.renderPlanList()}
          {this.renderViewPlan()}
        </div>`

The plan list is given the list of plans, the currently selected plan, and some
event handlers.

      renderPlanList: ->
        PlanList
          plans: @props.plans
          selectedPlan: @props.selectedPlan
          onAdd: @handleAddPlan
          onSelect: @props.onSelectPlan

If a plan is currently selected, we show it with the [`ViewPlan`][viewplan]
component. If there is no selection, we display a message saying so.

      renderViewPlan: ->
        if @props.selectedPlan
          ViewPlan
            plan: @props.selectedPlan
            recipes: @props.recipes
            onUpdate: @handleUpdatePlan
        else
          `<div>No plan currently selected.</div>`

When the user hits the add plan button, we want to create a new, empty plan and
re-render the view.

      handleAddPlan: ->
        @props.plans.create {}
        @forceUpdate()

When the user makes an update to a plan, we save the plan and re-render the
view.

      handleUpdatePlan: (plan) ->
        plan.save()
        @forceUpdate()

    module.exports = Index

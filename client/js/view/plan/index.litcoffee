# Index: Main Plans Component

The plans Index view manages the part of the application that allows arranging
recipes into meal plans.

    `/** @jsx React.DOM */`
    React = require 'react'
    {Plan, Plans} = require '../../model/plan'
    PlanList = require './plan_list'
    ViewPlan = require './view_plan'

    Index = React.createClass

This component maintains the application's list of plans. While recipes are
needed by multiple parts of the application, plans are only needed here, so
this is where we will maintain them as state.

      getInitialState: ->
        plans: new Plans
        selectedPlan: null

When the component is mounted, we will fetch and load the collection of plans.
When they have been loaded, we will refresh this view.

      componentDidMount: ->
        @state.plans.fetch().then =>
          @forceUpdate()

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
          plans: @state.plans
          selectedPlan: @state.selectedPlan
          onAdd: @handleAddPlan
          onSelect: @handleSelectPlan

If a plan is currently selected, we show it with the [`ViewPlan`][viewplan]
component. If there is no selection, we display a message saying so.

      renderViewPlan: ->
        if @state.selectedPlan
          ViewPlan
            plan: @state.selectedPlan
            onUpdate: @handleUpdatePlan
        else
          `<div>No plan currently selected.</div>`

When the user hits the add plan button, we want to create a new, empty plan and
re-render the view.

      handleAddPlan: ->
        @state.plans.create {}
        @forceUpdate()

When the user makes an update to a plan, we save the plan and re-render the
view.

      handleUpdatePlan: (plan) ->
        plan.save()
        @forceUpdate()

When the user selects a plan from the plan list, we update our state
appropriately.

      handleSelectPlan: (plan) ->
        @setState selectedPlan: plan

    module.exports = Index

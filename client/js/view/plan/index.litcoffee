# Index: Main Plans Component

The plans Index view manages the part of the application that allows arranging
recipes into meal plans.

    `/** @jsx React.DOM */`
    React = require 'react'
    {Plan, Plans} = require '../../model/plan'
    PlanList = require './plan_list'

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

      renderViewPlan: ->
        `<div>{this.state.selectedPlan && this.state.selectedPlan.get('name')}</div>`

When the user hits the add plan button, we want to create a new, empty plan and
re-render the view.

      handleAddPlan: ->
        @state.plans.create {}
        @forceUpdate()

When the user selects a plan from the plan list, we update our state
appropriately.

      handleSelectPlan: (plan) ->
        @setState selectedPlan: plan

    module.exports = Index

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

The plan list is given the list of plans as well as handler for when the user
wishes to add a new plan.

      renderPlanList: ->
        `<PlanList
          plans={this.state.plans}
          onAdd={this.handleAddPlan} />`

      renderViewPlan: ->
        `<div>View Plan</div>`

When the user hits the add plan button, we want to create a new, empty plan and
re-render the view.

      handleAddPlan: ->
        @state.plans.create {}
        @forceUpdate()

    module.exports = Index

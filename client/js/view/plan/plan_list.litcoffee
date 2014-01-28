# PlanList

PlanList displays a horizontal list of meal plans the user has created. It
allows a single plan to be selected and provides a way for the user to add a
new plan.

    `/** @jsx React.DOM */`
    require './plan_list.less'

    React = require 'react/addons'
    {classSet} = React.addons
    _     = require 'lodash'

    PlanList = React.createClass

The plan list shows a button for adding a new plan along with a scrollable list
of boxes for the list of plans.

      render: ->
        plans = @props.plans
        `<div className="row plan-list">
          <div className="col-sm-1">
            <button className="btn btn-success btn-block" onClick={this.props.onAdd}>+ Plan</button>
          </div>
          {plans.isEmpty()
            ? <div>You have no plans.</div>
            : plans.map(this.renderPlan)}
        </div>`

Each plan is shown in a `PlanBox` component which is described later.

      renderPlan: (plan) ->
        PlanBox
          key: plan.id
          plan: plan
          isSelected: plan.id is @props.selectedPlan?.id
          onClick: @handleSelect.bind @, plan

When a plan is clicked, we call back to the [parent component][index] to update
the selected plan.

[index]: ./index.litcoffee

      handleSelect: (plan) -> @props.onSelect plan

## PlanBox

Each plan is displayed with its name and number of days. The latter will
probably change as more functionality is added to plans.

    PlanBox = React.createClass
      render: ->
        `<div className="col-sm-2" onClick={this.props.onClick}>
          <div className={this.panelClasses()}>
            <div className="panel-body">
              <div>{this.props.plan.get('name')}</div>
              <div>{this.props.plan.get('meals').length} days</div>
            </div>
          </div>
        </div>`

We apply an `active` class to the panel if the plan is the currently selected
one.

      panelClasses: ->
        classSet
          'panel': true
          'panel-default': true
          'active': @props.isSelected

    module.exports = PlanList

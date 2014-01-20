# PlanList

PlanList displays a horizontal list of meal plans the user has created. It
allows a single plan to be selected and provides a way for the user to add a
new plan.

    `/** @jsx React.DOM */`
    React = require 'react'
    _     = require 'lodash'

    PlanList = React.createClass

The plan list shows a button for adding a new plan along with a scrollable list
of boxes for the list of plans.

      render: ->
        plans = @props.plans
        `<div className="row">
          <div className="col-md-12">
            <button className="btn btn-success" onClick={this.props.onAdd}>Add Plan</button>
          </div>
          {plans.isEmpty()
            ? <div>You have no plans.</div>
            : plans.map(this.renderPlan)}
        </div>`

Each plan is shown in a `PlanBox` component which is described later.

      renderPlan: (plan) ->
        `<PlanBox key={plan.id} plan={plan} />`

## PlanBox

Each plan is displayed with its name and number of days. The latter will
probably change as more functionality is added to plans.

    PlanBox = React.createClass
      render: ->
        `<div className="col-sm-2">
          <div className="panel panel-default">
            <div className="panel-body">
              <div>{this.props.plan.get('name')}</div>
              <div>{this.props.plan.get('dayCount')} days</div>
            </div>
          </div>
        </div>`

    module.exports = PlanList

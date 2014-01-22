# Meals Plan Field

This component allows the user to add meals to a plan.

    `/** @jsx React.DOM */`
    React = require 'react'

    Meals = React.createClass

We render a panel for each day.

      render: ->
        days = [1..@props.plan.get('dayCount')]
        `<div className="row">
          {days.map(this.renderDay)}
        </div>`

Each day has a header, and shows a list of the meals planned for that day.

      renderDay: (day) ->
        `<div className="col-md-2">
          <div className="panel panel-default">
            <div className="panel-heading">
              Day {day}
            </div>
            <div className="panel-body">
              No meals.
            </div>
          </div>
        </div>`

    module.exports = Meals

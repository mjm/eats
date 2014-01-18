`/** @jsx React.DOM */`

React = require 'react'
_     = require 'lodash'

key = require '../../util/key'
EditKeys = require '../common/edit_keys'

Container = React.createClass
  render: ->
    `<div>
      <h4>Ingredients</h4>
      <div className="ingredients" onClick={this.props.onClick}>
        {this.props.children}
      </div>
    </div>`

exports.View = React.createClass
  renderIngredient: (ingredient) ->
    `<li>{ingredient}</li>`

  render: ->
    ingredients = @props.ingredients
    `<Container onClick={this.props.onClick}>
      {_.isEmpty(ingredients)
        ? <span>Click to add ingredients.</span>
        : <ul>{ingredients.map(this.renderIngredient)}</ul>}
    </Container>`

EditIngredient = React.createClass
  mixins: [EditKeys]

  render: ->
    `<div className="form-group">
      <div className="input-group">
        <input
          type="text"
          className="form-control input-sm"
          onChange={this.props.onChange}
          onKeyDown={this.handleKeyDown}
          autoFocus={this.props.autoFocus}
          value={this.props.ingredient} />
        <div className="input-group-btn">
          <button type="button" className="btn btn-danger btn-sm" onClick={this.props.onRemove}>
            <span className="glyphicon glyphicon-remove" />
          </button>
        </div>
      </div>
    </div>`

  handleCancel: (e) ->
    @props.onCancel e

  handleSubmit: (e) ->
    @props.onSubmit e

  handleKeyDown: (e) ->
    if e.keyCode is key.DOWN
      @props.onDown e
    else if e.keyCode is key.UP
      @props.onUp e
    else
      @handleEditKeys e

exports.Edit = React.createClass
  getInitialState: ->
    if _.isEmpty @props.ingredients
      newIngredients: ['']
    else
      newIngredients: _.clone(@props.ingredients)

  renderIngredient: (ingredient, index) ->
    EditIngredient
      ingredient: ingredient
      autoFocus: index is 0
      onChange: @handleChange.bind @, index
      onSubmit: @handleSubmit
      onCancel: @handleCancel
      onDown: @handleDown.bind @, index
      onUp: @handleUp.bind @, index
      onRemove: @handleRemove.bind @, index

  render: ->
    `<Container>
      <form action="#" onSubmit={this.handleSubmit} role="form">
        {this.state.newIngredients.map(this.renderIngredient)}
        <p>
          <button type="submit" className="btn btn-primary btn-sm">Save</button>
          <button type="button" className="btn btn-link btn-sm" onClick={this.handleCancel}>Cancel</button>
        </p>
      </form>
    </Container>`

  handleChange: (index, e) ->
    ingredients = _.clone @state.newIngredients
    ingredients[index] = e.target.value
    @setState newIngredients: ingredients

  handleSubmit: (e) ->
    e.preventDefault()
    @props.onSave _.without(@state.newIngredients, '')

  handleCancel: ->
    @props.onSave(@props.ingredients)

  handleDown: (index, e) ->
    e.preventDefault()
    if index + 1 < @state.newIngredients.length
      @selectAdjacent e.target, 'next'
    else unless _.isEmpty @state.newIngredients[index]
      @setState newIngredients: @state.newIngredients.concat(''), =>
        $(@getDOMNode()).find('.form-group:last input').focus()

  handleUp: (index, e) ->
    ingredients = @state.newIngredients

    e.preventDefault()
    if index > 0
      @selectAdjacent e.target, 'prev'
      if index is ingredients.length - 1 and _.isEmpty(ingredients[index])
        @setState newIngredients: _.first(ingredients, ingredients.length - 1)

  selectAdjacent: (el, direction) ->
    $(el).closest('.form-group')[direction]('.form-group').find('input').focus()

  handleRemove: (index, e) ->
    @setState newIngredients: _.reject(@state.newIngredients, (_, i) -> i is index)

# Recipe Ingredients Field

This module provides the view and edit control for a recipe's list of
ingredients.

    `/** @jsx React.DOM */`

    React = require 'react'
    _     = require 'lodash'

    key = require '../../../util/key'
    EditKeys = require '../../common/edit_keys'

For ingredients, we have a common container component for both the view and
edit components. This ensures consistent markup when switching modes.

    Container = React.createClass
      render: ->
        `<div>
          <h4>Ingredients</h4>
          <div className="ingredients" onClick={this.props.onClick}>
            {this.props.children}
          </div>
        </div>`

## View

    exports.View = React.createClass

Ingredients are displayed as an unordered list. If there are no ingredients,
we show a message the user can click to begin editing.

      render: ->
        ingredients = @props.ingredients
        `<Container onClick={this.props.onClick}>
          {_.isEmpty(ingredients)
            ? <span>Click to add ingredients.</span>
            : <ul className="fa-ul">{ingredients.map(this.renderIngredient)}</ul>}
        </Container>`

Each ingredient is a simple list item.

      renderIngredient: (ingredient, index) ->
        `<li key={index}>
          <i className="fa-li fa fa-flask" />{' ' + ingredient}
        </li>`

## Edit

Ingredients are edited as a list of text fields, one for each ingredient.

    exports.Edit = React.createClass

There is no way to edit anything if the recipe has an empty list of
ingredients, so we make sure there's at least one ingredient in the list even
if the real list is empty.

      getInitialState: ->
        newIngredients: if _.isEmpty @props.ingredients then [''] else @props.ingredients

Each form control is its own component. We also provide Save and Cancel buttons
below the list.

      render: ->
        `<Container>
          <form action="javascript:;" onSubmit={this.handleSubmit} role="form">
            {this.state.newIngredients.map(this.renderIngredient)}
            <p>
              <button type="submit" className="btn btn-primary btn-sm">Save</button>
              <button type="button" className="btn btn-link btn-sm" onClick={this.handleCancel}>Cancel</button>
            </p>
          </form>
        </Container>`

The component for each ingredient is defined later on. It provides several
callbacks for all the ways we can interact with ingredients. Each callback is
bound to the index of the ingredient so we can properly manipulate the
ingredient list. We also make sure to initially focus the first ingredient.

      renderIngredient: (ingredient, index) ->
        EditIngredient
          key: index
          ingredient: ingredient
          autoFocus: index is 0
          onChange: @handleChange.bind @, index
          onSubmit: @handleSubmit
          onCancel: @handleCancel
          onDown:   @handleDown.bind   @, index
          onUp:     @handleUp.bind     @, index
          onEnter:  @handleEnter.bind  @, index
          onRemove: @handleRemove.bind @, index

When an ingredient is changed, we update the value at its index to have the new
text.

      handleChange: (index, value) ->
        @setState newIngredients: _.tap _.clone(@state.newIngredients), (ing) -> ing[index] = value

When saving, we remove any blank ingredients from the list.

      handleSubmit: -> @props.onSave _.without @state.newIngredients, ''
      handleCancel: -> @props.onSave @props.ingredients

When the user hits the down key, we move the focus to the next ingredient in
the list. If they are already at the bottom and the last ingredient isn't
blank, we add a new empty ingredient to the bottom and focus it.

      handleDown: (index, e) ->
        if index + 1 < @state.newIngredients.length
          @selectAdjacent e.target, 'next'
        else unless _.isEmpty @state.newIngredients[index]
          @setState newIngredients: @state.newIngredients.concat(''), =>
            $(@getDOMNode()).find('.form-group:last input').focus()

When the user hits the up key, we move the focus to the previous ingredient in
the list. If we are moving up from an empty final ingredient, we remove that
ingredient from our list.

      handleUp: (index, e) ->
        ingredients = @state.newIngredients

        if index > 0
          @selectAdjacent e.target, 'prev'
          if index is ingredients.length - 1 and _.isEmpty ingredients[index]
            @setState newIngredients: _.first ingredients, ingredients.length - 1

We use the enter key to allow adding ingredients in the middle of the list.

      handleEnter: (index, e) ->
        ingredients = _.clone @state.newIngredients
        ingredients.splice index+1, 0, ''
        @setState newIngredients: ingredients, =>
          @selectAtIndex index+1

Removing an ingredient, whether by keyboard or by clicking the button, we
focus the item above it.

      handleRemove: (index, e) ->
        @setState newIngredients: _.reject(@state.newIngredients, (_, i) -> i is index), =>
          @selectAtIndex Math.max 0, index - 1

We use a helper function for moving up and down between ingredients, and
another for focusing a specific index.

      selectAdjacent: (el, direction) ->
        $(el).closest('.form-group')[direction]('.form-group').find('input').focus()

      selectAtIndex: (index) ->
        $(@getDOMNode()).find(".form-group:eq(#{index}) input").focus()

### Editing an Individual Ingredient

    EditIngredient = React.createClass

Each ingredient has the same [edit keys][editkeys] as all our other editing
controls.

[editkeys]: ../../common/edit_keys.litcoffee

      mixins: [EditKeys]

Each ingredient is a text field combined with a remove button at the end.

      render: ->
        `<div className="form-group">
          <div className="input-group">
            <input
              type="text"
              className="form-control input-sm"
              onChange={this.handleChange}
              onKeyDown={this.handleKeyDown}
              autoFocus={this.props.autoFocus}
              value={this.props.ingredient} />
            <div className="input-group-btn">
              <button type="button" className="btn btn-danger btn-sm" onClick={this.props.onRemove}>
                <i className="fa fa-trash-o" />
              </button>
            </div>
          </div>
        </div>`

Most handlers just callback to the parent component. The editor for the list
maintains the state, and is therefore responsible for manipulating the list.

      handleCancel: (e) -> @props.onCancel e
      handleSubmit: (e) -> @props.onSubmit e
      handleChange: (e) -> @props.onChange e.target.value

This component breaks down the various key events into separate callbacks for
the parent. This essentially acts as a dispatcher.

      handleKeyDown: (e) ->
        if e.keyCode is key.DOWN
          e.preventDefault()
          @props.onDown e
        else if e.keyCode is key.UP
          e.preventDefault()
          @props.onUp e
        else if e.keyCode is key.ENTER
          e.preventDefault()
          @props.onEnter e
        else if e.keyCode is key.BACKSPACE and _.isEmpty @props.ingredient
          e.preventDefault()
          @props.onRemove e
        else
          @handleEditKeys e

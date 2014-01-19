# ViewRecipe: Recipe Viewer and Editor

The ViewRecipe component allows the user to view or edit a single [recipe][].
It does so by allowing at most one field to be in edit mode at any given time.

[recipe]: ../../model/recipe.litcoffee

    `/** @jsx React.DOM */`

    require './view_recipe.less'

    React = require 'react'
    _     = require 'lodash'

    Controls = require './controls'

Each field ([name][], [ingredients][], [instructions][], [tags][]) has a
separate component for viewing or editing. We will render the appropriate
component based on the `editing` key in our state.

[name]: field/name.litcoffee
[ingredients]: field/ingredients.litcoffee
[instructions]: field/instructions.litcoffee
[tags]: field/tags.litcoffee

    {Edit: EditName,         View: ViewName}         = require './field/name'
    {Edit: EditIngredients,  View: ViewIngredients}  = require './field/ingredients'
    {Edit: EditInstructions, View: ViewInstructions} = require './field/instructions'
    {Edit: EditTags,         View: ViewTags}         = require './field/tags'

    ViewRecipe = React.createClass

Initially, all fields are in view mode.

      getInitialState: -> editing: null

When we receive new properties, we check if we are switching recipes. If so, we
go back to viewing all fields. It would feel strange to continue editing the
same field on a different recipe, so we reset this when switching.

      componentWillReceiveProps: (nextProps) ->
        @setState editing: null if nextProps.recipe.cid isnt @props.recipe.cid

This component displays as a Bootstrap panel with the [name][] in the header,
[ingredients][] and [instructions][] in the body, and [tags][] and [controls][]
in the footer.

[controls]: controls.litcoffee

      render: ->
        recipe = @props.recipe.toJSON()
        editing = @state.editing

We create convenience functions for wiring up the handlers that toggle a field
between viewing and editing. Clicking a field that's in view mode allows you to
edit it. There are several different ways to go from editing back to viewing.

        editHandler = (field) => _.partial @handleEdit, field
        saveHandler = (field) => _.partial @handleSave, field

        `<div className="col-md-9">
          <div className="panel panel-default view-recipe">
            <div className="panel-heading" onClick={editHandler('name')}>
              {editing === 'name'
                ? <EditName name={recipe.name} onSave={saveHandler('name')} />
                : <ViewName name={recipe.name} />}
            </div>
            <div className="panel-body">
              {editing === 'ingredients'
                ? <EditIngredients ingredients={recipe.ingredients} onSave={saveHandler('ingredients')} />
                : <ViewIngredients ingredients={recipe.ingredients} onClick={editHandler('ingredients')} />}
              <div className="instructions">
                <h4>Instructions</h4>
                {editing === 'instructions'
                  ? <EditInstructions instructions={recipe.instructions} onSave={saveHandler('instructions')} />
                  : <ViewInstructions instructions={recipe.instructions} onClick={editHandler('instructions')} />}
              </div>
            </div>
            <div className="panel-footer clearfix">
              <Controls onDelete={_.partial(this.props.onDelete, this.props.recipe)} />
              {editing === 'tags'
                ? <EditTags tags={recipe.tags} onSave={saveHandler('tags')} />
                : <ViewTags tags={recipe.tags} onClick={editHandler('tags')} />}
            </div>
          </div>
        </div>`

Editing a field is as simple as updating the current state. React re-renders
with the field in edit mode.

      handleEdit: (field) -> @setState editing: field

Saving a field updates the property on the recipe with the new value. The
parent component is responsible for saving the model. We also put the field
back into view mode.

This handler is also currently used for cancelling draft changes. The field
components handle cancelling by calling the save handler with the original value.
This allows us to reuse the handler.

      handleSave: (field, newValue) ->
        @props.recipe.set field, newValue
        @props.onUpdate @props.recipe
        @setState editing: null

    module.exports = ViewRecipe

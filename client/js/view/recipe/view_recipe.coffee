`/** @jsx React.DOM */`

require './view_recipe.less'

React = require 'react'
_     = require 'lodash'

{Edit: EditName,         View: ViewName}         = require './field/name'
{Edit: EditIngredients,  View: ViewIngredients}  = require './field/ingredients'
{Edit: EditInstructions, View: ViewInstructions} = require './field/instructions'
{Edit: EditTags,         View: ViewTags}         = require './field/tags'
Controls = require './controls'

ViewRecipe = React.createClass
  getInitialState: -> editing: null

  componentWillReceiveProps: (nextProps) ->
    @setState editing: null if nextProps.recipe.cid isnt @props.recipe.cid

  render: ->
    recipe = @props.recipe.toJSON()
    editing = @state.editing

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
          <Controls onDelete={this.handleDelete} />
          {editing === 'tags'
            ? <EditTags tags={recipe.tags} onSave={saveHandler('tags')} />
            : <ViewTags tags={recipe.tags} onClick={editHandler('tags')} />}
        </div>
      </div>
    </div>`

  handleDelete: -> @props.onDelete @props.recipe
  handleEdit: (field) -> @setState editing: field

  handleSave: (field, newValue) ->
    @props.recipe.set field, newValue
    @props.onUpdate @props.recipe
    @setState editing: null

module.exports = ViewRecipe

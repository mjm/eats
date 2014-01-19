`/** @jsx React.DOM */`
React = require 'react'
_     = require 'lodash'

AddRecipe  = require './add_recipe'
TagList    = require './tag_list'
RecipeList = require './recipe_list'
ViewRecipe = require './view_recipe'

Index = React.createClass
  render: ->
    if @props.selectedTag
      filteredRecipes = @props.recipes.filter (recipe) =>
        _.contains recipe.get('tags'), @props.selectedTag
    else
      filteredRecipes = @props.recipes

    `<div className="row">
      <div className="col-md-3">
        <AddRecipe onAdd={this.handleAddRecipe} />
        <TagList
          tags={this.props.recipes.tags()}
          selectedTag={this.props.selectedTag}
          onSelect={this.props.onSelectTag} />
        <RecipeList
          recipes={filteredRecipes}
          selectedRecipe={this.props.selectedRecipe}
          onSelectRecipe={this.props.onSelectRecipe} />
      </div>
      {this.props.selectedRecipe
        ? <ViewRecipe
            recipe={this.props.selectedRecipe}
            onUpdate={this.handleUpdateRecipe}
            onDelete={this.handleDeleteRecipe} />
        : 'No recipe selected'}
    </div>`

  handleAddRecipe: ->
    @props.onAddRecipe @props.recipes.create tags: _.compact [@props.selectedTag]

  handleUpdateRecipe: (recipe) ->
    recipe.save()
    @props.onUpdateRecipe recipe

  handleDeleteRecipe: (recipe) ->
    recipe.destroy()
    @props.onDeleteRecipe recipe

module.exports = Index

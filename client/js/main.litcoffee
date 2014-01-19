# Entry Point

This file is the starting point of the application. It loads the [`Eats`][eats]
component and renders it into the body of the page.

[eats]: view/eats.litcoffee

    React = require 'react'
    Eats = require './view/eats'

    React.renderComponent Eats(), document.body

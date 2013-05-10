###requirejs.config
  paths:
    jquery: 'vendors/jquery/jquery'
    underscore: 'vendors/underscore/underscore'
    backbone: 'vendors/backbone/backbone'
    backbonels: 'vendors/backbone/backbone.localStorage'
    bootstrap: 'vendors/bootstrap/bootstrap'
    text: 'vendors/require/text'
  shim: 
    backbone:
      deps: ['jquery','underscore']
      exports: 'Backbone'
    underscore:
      exports: '_'
    bootstrap : 
      deps: ['jquery']
  wait: '5s'

# require 
require ['backbone', 'backbonels', 'jquery','application/models/application','bootstrap'],(Backbone,Backbonels,$,App) ->
#require ['backbone','jquery','application/models/application', 'bootstrap'],(Backbone,$,Application) ->
  $ ()->
    App = new App()
    App.init()
    console.log "launched"
    test = new Test()
    test.init()
    console.log 'test launched'###

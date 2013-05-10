# require configuration
# baseUrl: is the baseUrl of all the following path, relative to the index.html
# path: key value represent path shortcut to easierly depends from a library
# shim: allows non AMD libraries to be required and exports them
requirejs.config
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
require ['backbone', 'backbonels', 'jquery','application/models/application','bootstrap'],(Backbone,Backbonels,$,App,Bs) ->
#require ['backbone','jquery','application/models/application', 'bootstrap'],(Backbone,$,Application) ->
  $ ()->
    console.log "Alors?"
    App = new App()

    App.init()
    console.log "launched"





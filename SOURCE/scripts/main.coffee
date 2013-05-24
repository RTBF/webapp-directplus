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
    waypoints: 'vendors/jquery/waypoints'
    infinitescroll: 'vendors/jquery/infinitescroll'
    hammer: 'vendors/hammer/hammer'
    text: 'vendors/require/text'
  shim: 
    backbone:
      deps: ['jquery','underscore']
      exports: 'Backbone'
    underscore:
      exports: '_'
    bootstrap : 
      deps: ['jquery']
    waypoints :
      deps:['jquery']
    infinitescroll:
      deps:['jquery']
    hammer:
      deps:['jquery']
  wait: '5s'

# require 
require ['backbone', 'backbonels', 'jquery','application/models/application','bootstrap','waypoints','infinitescroll','hammer'],(Backbone,Backbonels,$,App,Bs,Wp,Is,Hm) ->
#require ['backbone','jquery','application/models/application', 'bootstrap'],(Backbone,$,Application) ->
  $ ()->
    App = new App()

    #App.init()
    console.log "launched"





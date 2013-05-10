define [
  'jquery'
  'backbone'
  'backbonels'
  'application/models/conference'
  ],($,Backbone,Backbonels,Conference)->


  class Conferences extends Backbone.Collection
    
    model : Conference

    localStorage: new Backbonels "slidesStore"
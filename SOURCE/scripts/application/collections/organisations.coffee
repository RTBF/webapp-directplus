define [
  'jquery'
  'backbone'
  'backbonels'
  'application/models/organisation'
  ],($,Backbone,Backbonels,Organisation)->


  class Organisations extends Backbone.Collection
    
    model : Organisation

    localStorage: new Backbonels "slidesStore"
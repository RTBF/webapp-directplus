define [
  'jquery'
  'backbone'
  'application/views/slideScreen'
  ],($,Backbone,slideScreen)->

    class Slide extends Backbone.Model

      defaults:
        Order: 0
     
      constructor: (aSlide)->
        super aSlide
         # ...

  

   
  

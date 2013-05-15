define [
  'jquery'
  'backbone'
  'application/views/slideScreen'
  ],($,Backbone,slideScreen)->

    class Slide extends Backbone.Model

      defaults:
        title:' '
        description: ' ' 
        Order: 0
     
      constructor: (aSlide)->
        super aSlide
         # ...

  

   
  

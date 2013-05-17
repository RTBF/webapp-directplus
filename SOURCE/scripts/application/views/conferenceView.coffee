define [
  'jquery'
  'backbone'
  'application/views/slideScreen'
  ],($,Backbone,SlideView)->

    class ConferenceView extends Backbone.View

      #el: '#appcontainer'
      
      tagName : 'li'
      className : 'conference'

      template : _.template($('#conf-template').html())

      initialize : ()->
       @listenTo @model, 'change:slidesC', @render
       @listenTo @model, 'new', @new
      

      render: ()-> 
        console.log "confView"
        @$el.html @template(@model.toJSON())
        $('#SlideList').children().remove()
        if $('#SlideList').is ':empty'
          @model.get('slidesC').each (slide)->
            console.log slide
            console.log slide.get('state')
            slideView = new SlideView 
              model : slide
            slideView.render()
        @

      new:()->
        console.log "render new"
        slide = @model.get('slidesC').at @model.get('slidesC').length - 1
        slideView = new SlideView 
          model : slide
        slide = @model.get('slidesC').where state:'future'
        if slide[0]
          slideView.render()
        else
          console.log "future doesn't exist"
          slideView.new()



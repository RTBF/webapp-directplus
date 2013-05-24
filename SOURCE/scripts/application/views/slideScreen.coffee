define [
  'jquery'
  'backbone'
  'application/views/conferenceView'
  'bootstrap'
  ],($,Backbone,ConferenceView)->

    class slideScreen extends Backbone.View
      tagName : 'li'
      className: "slide"

      template : _.template($('#slide-template').html())
      templateVideo : _.template($('#slide-video-template').html())

      initialize : ()->
        @listenTo @model, 'change', @render
        console.log  "slideScreen initilized"

      render: ()-> 
        console.log @model
        console.log @model.toJSON()
        console.log 'render called'
        #@.$el.html @template(@model.toJSON())
        modelId = '#'+@model.get('id')
        if @model.get('state') is 'removed'
          $(modelId).parent().slideUp()
          $(modelId).parent().remove()
          slidet=@model.get 'title'
          $('.bottom-right').notify
            type: 'inverse'
            message: 
              text: 'a slide had been removed: '+slidet
            fadeOut: 
              enabled: true
              delay: 1000 
          .show()
        else 
          if $(modelId).parent().hasClass('slide')
            console.log "lol"
            #@.$el.html @template(@model.toJSON())    
          else
            console.log 'je suis là'
            if @model.get('state') != 'out'
              console.log "not out"
              console.log @model.get 'Type'
              switch @model.get 'Type'
                when 'text'
                  $('#SlideList').append(@.$el.html @template(@model.toJSON()))

                  
                when 'video'
                  $('#SlideList').append(@.$el.html @templateVideo(@model.toJSON()))
                  
          $(modelId).parent().removeClass().addClass("slide").addClass(@model.get('state'))
          if @model.get('state') isnt  'current'
            $(modelId).parent().addClass 'scale'
            # ...
        $(modelId).parent().attr('style',' ')
          
        
        if @model.get('state') is 'out'
          $(modelId).parent().remove()
        
        #@
      
      new:()->
        modelId = '#'+@model.get('id')
        switch @model.get 'Type'
          when 'text'
            $('#SlideList').append(@.$el.html @template(@model.toJSON()))
            
          when 'video'
            $('#SlideList').append(@.$el.html @templateVideo(@model.toJSON()))
            
            
        $(modelId).parent().removeClass().addClass("slide").addClass(@model.get('state'))
        $(modelId).hide()
        $(modelId).fadeIn ()=>
          @model.set 'state', 'current'
        

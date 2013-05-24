define [
  'jquery'
  'backbone'
  'modernizr'
  ],($,Backbone,Modernizr)->

    class Carousel
      constructor: (element) ->
        console.log Modernizr;
        @elt=$(element)
        console.log element
        console.log @elt
        @tempcontainer = element + " > ul"
        @templi = element + " > ul  li"
        @tempcurrent= element + " li.current"
        @currentSlide = $(@tempcurrent)
        console.log  @currentSlide
        @width = @currentSlide.width()
        @container = $(@tempcontainer)
        @slides = $(@templi)
        @current = 0
        @count = 1

      init:()->
        @elt.hammer({ drag_lock_to_axis: true }).on "release dragleft dragright swipeleft swiperight", @handleHammer

      stick:(percent, deltaX)->
        ###if Modernizr.csstransforms3d 
          $(@tempcurrent).css("transform", "translate3d("+percent+"%,0,0) scale3d(1,1,1)");
            
        else if Modernizr.csstransforms
          $(@tempcurrent).css("transform", "translate("+percent+"%,0)")
            
        else### 
        $(@tempcurrent).css "left", deltaX
            
        

      handleHammer:(ev)=>
        ev.gesture.preventDefault()
        
        
        switch ev.type
          
          when 'dragright'
            console.log $(@tempcurrent).css 'left'
            console.log $(@tempcurrent).css 'margin-left'
            taille = parseInt $("#appcontainer").width()
            percent = (ev.gesture.deltaX/taille)*100 
            strpx = ev.gesture.deltaX+"px"
            @stick(percent, strpx)
            
          when 'dragleft'
            console.log $(@tempcurrent).css 'left'
            console.log $(@tempcurrent).css 'margin-left'
            taille = parseInt $("#appcontainer").width()
            percent = (ev.gesture.deltaX/taille)*100 
            strpx= ev.gesture.deltaX+"px"
            @stick(percent, strpx)

          when 'swipeleft'
            $('#suivant').click()
            ev.gesture.stopDetect()
            $(@tempcurrent).css('left','0px')
          when 'swiperight'
            $('#precedent').click()
            ev.gesture.stopDetect()
            $(@tempcurrent).css('left','0px')
            #$(@tempcurrent).attr('style',' ')
          when 'release'
            pane_width = $(@tempcurrent).width()
            if Math.abs(ev.gesture.deltaX) > pane_width/2
              $('#suivant').click()
              ev.gesture.stopDetect()

            else
              $('#precedent').click()
              ev.gesture.stopDetect()

            #$(@tempcurrent).attr('style',' ')


            # ...
          
        


        # ...
      
    

define [
  'jquery'
  'backbone'
  ],($,Backbone)->

    class Carousel
      constructor: (element) ->
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
        

      handleHammer:(ev)=>
        console.log ev.gesture.deltaX
        ev.gesture.preventDefault()
        switch ev.type
          
          when 'dragright'
            strpx = ev.gesture.deltaX+"px"
            $(@tempcurrent).css "margin-left", strpx
            
          when 'dragleft'
            strpx= ev.gesture.deltaX+"px"
            $(@tempcurrent).css "margin-left", strpx

          when 'swipeleft'
            $('#suivant').click()
            ev.gesture.stopDetect()
            $(@tempcurrent).attr('style',' ')
          when 'swiperight'
            $('#precedent').click()
            ev.gesture.stopDetect()
            $(@tempcurrent).attr('style',' ')
          when 'release'
            pane_width = $(@tempcurrent).width()
            if Math.abs(ev.gesture.deltaX) > pane_width/3
              $('#suivant').click()
              ev.gesture.stopDetect()

            else
              $('#precedent').click()
              ev.gesture.stopDetect()
            $(@tempcurrent).attr('style',' ')


            # ...
          
        


        # ...
      
    

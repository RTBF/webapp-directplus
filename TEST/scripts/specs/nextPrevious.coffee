define ['jquery'],($)->

  describe "As user I want to be able to go back to a previous slide",()->
    #TEST1
    describe "test that the previous slide is shown", ()->
      it "should display the previous slide received", ()->
        
        found = null
        runs ()->
          found = false
        testpreviousSlide = ->
            $('#SlideList>li').each (index,elem)->
              if $(elem).hasClass('future')
                found = true
            if found
              return true
            else
              return false
        waitsFor testpreviousSlide, "previous slide found", 10000
        runs ()->
          expect(found).toBe(true)
    
    #TEST2
    describe "test that the next slide is shown", ()->
      it "should display the next slide received", ()->
        
        found = null
        nextId = null
        
        runs ()->
          found = false
        
        testpreviousSlide = ->
          nextId=$(".future").children().attr('id')
          testnextSlide = ->
            if $(".current").children().attr('id') == nextId
              found = true
              return true
            else 
              return false
          waitsFor testnextSlide, "next slide found", 10000
          return true

        waitsFor testpreviousSlide, "previous slide found", 10000
        
        runs ()->
          expect(found).toBe(true)

   

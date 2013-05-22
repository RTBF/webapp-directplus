define [
  'jquery'
  'backbone'
  'application/collections/slides'
  'application/models/slide'
  ],($,Backbone,Slides,Slide)->

    class Conference extends Backbone.Model

      defaults:
        name: ' '
        thumb: ' '
        description: ' '
        date: new Date()
        slidesC: new Slides()

      constructor: (aConf)->
        super aConf
         # ...

      initialize:()->
        @get('slidesC').comparator = ()=>
          slide = new Slide()
          slide.get 'Order'
        @get('slidesC').sort()
        @navMode = false
        @on 'slides', (data)=>
          @restore data
        @on 'newSlide', (data)=>
          @newSlide data
        @on 'next', ()=>
          @next()
        @on 'previous', ()=>
          @previous()
        @on 'sremove',(data)=>
          @remove(data) 

      restore: (data)->
        @navMode = false
        console.log "j'ai été restaurement"
        console.log @get('slidesC')
        @get('slidesC').fetch()
        len = data.length - 1
        slideLen = @get('slidesC').length - 1

        
        
        @get('slidesC').reset()
        localStorage.clear()
        @get('slidesC').fetch()
        for x in [0..len]
          obj = $.parseJSON data[x].JsonData
          obj.id = data[x]._id
          slide = new Slide obj
          @get('slidesC').add slide
          slide.save()
          @get('slidesC').fetch()
        @get('slidesC').each (slide)->
          slide.set 'state', 'out'
        taille = @get('slidesC').length
        max = 3
        while (max>0 && taille>0)
          taille--
          slide = @get('slidesC').at taille
          switch max
            when 3
              slide.set 'state', 'current'
            when 2
              slide.set 'state', 'past'
            when 1
              slide.set 'state', 'far-past'
          max--
        console.log @get('slidesC')
        console.log @get('slidesC')
        @trigger 'change:slidesC'

      newSlide: (data)->
        
        obj = $.parseJSON data.JsonData
        obj.id = data._id
        slide = new Slide obj
        if @navMode
          slideff = @get('slidesC').where state:'far-future'
          if slideff[0]
            slide.set 'state', 'out'
          else
            slide.set 'state', 'far-future'
        else
          slide.set 'state', 'far-future'
          taille = @get('slidesC').length
          max = 3
          while (max>0 && taille>0)
            taille--
            slidet = @get('slidesC').at taille
            switch max
              when 3
                slidet.set 'state', 'past'
              when 2
                slidet.set 'state', 'far-past'
              when 1
                slidet.set 'state', 'out'
            max--
            
        @get('slidesC').add slide
        slide.save()
        @get('slidesC').fetch
        console.log @get('slidesC')
        console.log "AAAAAAAAAreceived new slides"
        @trigger 'new'


      next:()->
        slideff = @get('slidesC').where state:'current'
        index = @get('slidesC').indexOf slideff[0]
        if index < @get('slidesC').length-1
          i= index
          max = index
          min = index-1
          while (max< @get('slidesC').length && max < index+5 )
            slidem = @get('slidesC').at(max)
            switch max
              when index
                slidem.set 'state', 'past'
              when index+1 
                slidem.set 'state', 'current'
              when index+2
                slidem.set 'state', 'future'
              when index+3 
                slidem.set 'state', 'far-future'
              when index+4 
                slidem.set 'state', 'out'
            max++

          while (min>=0 && min > index-3)
            slidem = @get('slidesC').at(min)
            switch min
              when index-1
                slidem.set 'state', 'far-past'
              when index-2
                slidem.set 'state', 'out'
            min--
        if index+1 is @get('slidesC').length-1
          @navMode = false
        console.log @navMode

      previous:()->
        slideff = @get('slidesC').where state:'current'
        index = @get('slidesC').indexOf slideff[0]
        if index > 0
          i = index
          max = index
          min = index-1
          console.log "le i vaut", i
          while ((max<@get('slidesC').length) && (max<index+3))
            slidem = @get('slidesC').at(max)
            console.log max
            switch max
              when i
                slidem.set 'state', 'future'
              when i+1
                slidem.set 'state', 'far-future'
              when i+2
                slidem.set 'state', 'out'
            max++
            
            
          i = index-1
          console.log min
          while ((min>=0) && (min > index-4))
            slidem = @get('slidesC').at(min)
            console.log "min vaut", min
            switch min
              when i
                slidem.set 'state', 'current'
              when i-1
                slidem.set 'state', 'past'
              when i-2
                slidem.set 'state', 'far-past'
              when i-3
                slidem.set 'state', 'out'
            min--
          @navMode = true  
       
        console.log @navMode  
        console.log @get('slidesC')

      remove:(data)->
        slideff = @get('slidesC').where state:'current'
        currentPos = @get('slidesC').indexOf slideff[0]
        console.log "current pos", currentPos
        obj = $.parseJSON data.JsonData
        slideToRemove = @get('slidesC').get(data._id)
        state = slideToRemove.get("state")
        removePos= @get('slidesC').indexOf slideToRemove
        @get('slidesC').get(data._id).set 'state', 'removed'
        @get('slidesC').localStorage.destroy(@get('slidesC').get(data._id))
        @get('slidesC').remove @get('slidesC').get(data._id)

        if state is 'current'
          if @navMode 
            taille = @get('slidesC').length
            max = currentPos
            while (max<taille && max<currentPos+4)
              slidem = @get('slidesC').at(max)
              switch max
                when currentPos
                  slidem.set 'state', 'current'
                when currentPos+1
                  slidem.set 'state', 'future'
                when currentPos+2
                  slidem.set 'state', 'far-future'
                 when currentPos+3
                  slidem.set 'state', 'out'
              max++
            if @get('slidesC').at(@get('slidesC').length-1).get('state') is "current"
              @navMode = false  

          else       
            currentPos = currentPos-1
            min = currentPos
            while ((min>=0) && (min > currentPos-4))
              slidem = @get('slidesC').at(min)
              switch min
                when currentPos
                  slidem.set 'state', 'current'
                when currentPos-1
                  slidem.set 'state', 'past'
                when currentPos-2
                  slidem.set 'state', 'far-past'
                when currentPos-3
                  slidem.set 'state', 'out'
              min--
      
        else
          if removePos>currentPos && removePos<currentPos+3
            console.log 'je suis au dessus du current'
            taille = @get('slidesC').length
            max = currentPos+1
            while (max<taille && max<currentPos+4)
              slidem = @get('slidesC').at(max)
              switch max
                when currentPos+1
                  slidem.set 'state', 'future'
                when currentPos+2
                  slidem.set 'state', 'far-future'
                when currentPos+3
                  slidem.set 'state', 'out'
              max++
          else
            if removePos<currentPos && removePos>currentPos-3
              console.log "je suis en dessous du current"
              currentPos=currentPos-1
              min = currentPos-1
              while ((min>=0) && (min > currentPos-3))
                slidem = @get('slidesC').at(min)
                console.log "min vaut", min
                switch min
                  when currentPos-1
                    slidem.set 'state', 'past'
                  when currentPos-2
                    slidem.set 'state', 'far-past'
                  when currentPos-3
                    slidem.set 'state', 'out'
                min--

        #@get('slidesC').fetch()


          







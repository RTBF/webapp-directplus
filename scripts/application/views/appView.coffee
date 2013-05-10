define [
  'jquery'
  'backbone'
  'application/models/slide'
  'application/views/slideScreen'
  'application/collections/slides'
  'application/models/organisation'
  'application/views/organisationView'
  'application/models/conference'
  'application/views/conferenceView'
  ],($,Backbone,Slide,SlideView,Slides,Organisation,OrganisationView,Conference, ConferenceView)->

   

    class appView extends Backbone.View
   

      el: '#header'

      template : _.template($('#app-template').html())

      ###--events:
        'click #previous' : 'previous'
        'click #next' : 'next'###


      initialize : ()->
        @slides = new Slides()
        @render()
        @on 'newSlide', (data) =>
          @newSlide data
        @on 'ServerConnection' , (data)=>
          @connectNotif data
        @on 'reseting' , (data)=>
          console.log "reseting"
          @slides.reset()
          @slides.position= 0
          @navigationMode = false
        @on 'organisations', (data)=>
          @fullFillOrgList data
        @on 'conferences', (data)=>
          @fullFillConfList data
        @on 'slides', (data)=>
          @restore data
        @on 'sremove', (data)=>
          @removeSlide data
        @slides.fetch()

        $('#appcontainer').delegate '.org-item', 'click', (e)=>
          console.log e.target
          txt = $(e.target).attr('id')
          console.log txt
          @trigger 'organisationChoosed', txt


        $('#appcontainer').delegate '.conf-item' ,'click ', (e)=>
          txt = $(e.target).attr('id')
          @conference = $(e.target).attr('id')
          console.log txt
          @trigger 'conferenceChoosed', txt

        $('#suivant').click (e)=>
          e.preventDefault()
          @suivant()
          console.log "pushed next bt"
        
        $('#precedent').click (e)=>
          e.preventDefault()
          @precedent()
          console.log "pushed previous bt"

        console.log "appView built"
        


        
        #@restore()

      connectNotif : (data)->
        $('.js-status').removeClass('disconnected').addClass('connected')

      render: ()-> 
        @$el.html @template()
        #@

      precedent: ()->
        console.log @slides.position
        if @slides.position>0
          $('.far-future').remove()
          $('.future').removeClass('future').addClass('far-future')
          $('.current').removeClass('current').addClass('future')
          $('.past').removeClass('past').addClass('current')
          $('.far-past').removeClass('far-past').addClass('past')
          @slides.position = @slides.position-1
          previous = @slides.at(@slides.position)
          @navigationMode = true;
          
          if @slides.position > 1
            newPosSlide = @slides.position - 2 
            slide = @slides.at newPosSlide
            slideView = new SlideView 
              model : slide
            $('#SlideList').append(slideView.render().el)
            $('.new').removeClass('new').addClass('far-past')
          
        console.log "Mode navigation?: ", @navigationMode
        console.log  "ma position: ", @slides.position

         

      suivant: ()->
        if (@slides.position < (@slides.length-1))
          console.log "I am in"
          $('.far-past').remove()
          $('.past').removeClass('past').addClass('far-past')
          $('.current').removeClass('current').addClass('past')
          $('.future').removeClass('future').addClass('current')
          $('.far-future').removeClass('far-future').addClass('future')
          
          @slides.position = @slides.position+1
          previous = @slides.at(@slides.position)
          
          if @slides.position is (@slides.length-1)
            @navigationMode = false
            # ...

          if @slides.position < (@slides.length-2)
            newPosSlide = @slides.position + 2 
            slide = @slides.at newPosSlide
            slideView = new SlideView 
              model : slide
            $('#SlideList').append(slideView.render().el)
            $('.new').removeClass('new').addClass('far-future') 

        console.log "Mode navigation?: ", @navigationMode

       
        console.log  "ma position: ", @slides.position
          

      newSlide: (data)->
        obj = $.parseJSON data.JsonData
        slide = new Slide obj
        slide.set("conf", data._conf)
        slideView = new SlideView ({model : slide })
        @slides.add slide
        slide.save()
        @slides.fetch()

        ###slide = new Slide data
        slideView = new SlideView ({model : slide })
        @slides.add slide
        slide.save()
        @slides.fetch()###
        if @navigationMode
          if (@slides.position is @slides.length-3)
            $('#SlideList').append(slideView.render().el)
            $('.new').removeClass('new').addClass('far-future') 
          #
        else
          @slides.position = @slides.length-1
          $('#SlideList').append(slideView.render().el)
          @last()
        console.log "Mode navigation?: ", @navigationMode
        console.log  "ma position: ", @slides.position

      removeSlide: (data)->
        console.log data
        obj = $.parseJSON data.JsonData
        slide = new Slide obj
        slide.set("conf", data._conf)
        index= @slides.indexOf @slides.get(obj.id)
        @slides.localStorage.destroy(@slides.get(obj.id))
        @slides.remove @slides.get(obj.id)
        @slides.fetch()
        id= '#'+obj.id
        console.log "la position en index of: ", index
        console.log "la position en position: ", @slides.position
        if index < @slides.position
          @slides.position = @slides.position - 1

        if $(id).parent().hasClass('far-future')
          $(id).parent().remove()
          @hasNext()

        else if $(id).parent().hasClass('future')
          $(id).parent().slideUp ()->
            $(id).parent().remove()
          $('.far-future').removeClass('far-future').addClass("future")
          @hasNext()
          @setNavigationMode()
        
        else if $(id).parent().hasClass('current')
          $(id).parent().slideUp ()->
            $(id).parent().remove()
          if @navigationMode 
            console.log "c'est pcq je suis en mode navigation"
            $('.future').removeClass('future').addClass('current')
            $('.far-future').removeClass('far-future').addClass('future')
            @hasNext()
            @setNavigationMode()
            
          else
            console.log "c pcq je ne suis pas en mode navigation"
            $('.past').removeClass('past').addClass('current')
            $('.far-past').removeClass('far-past').addClass('past')
            @slides.position = @slides.position-1
            @navigationMode = false;
           
        
        else if $(id).parent().hasClass('past')
          $(id).parent().slideUp ()->
            $(id).parent().remove();
          $('.far-past').removeClass('far-past').addClass("past")
          @hasPrevious()
        
        else if $(id).parent().hasClass('far-past')
          $(id).parent().remove()
          @hasPrevious()
          

      fullFillOrgList: (data)->
        $(".organisationsList").children().remove()
        len = data.length - 1
        console.log len
        for x in [0..len]
          organisation = new Organisation data[x]
          console.log organisation
          organisationView = new OrganisationView ({model:organisation})
          $('.organisationsList').append(organisationView.render().el)
        
        $("#loading").fadeOut()
        $("#wrap").fadeIn()

        

  
      fullFillConfList: (data)->
        $(".confList").children().remove()
        len = data.length - 1

        for x in [0..len]
          console.log data[x]
          confs = new Conference data[x]
          confView = new ConferenceView ({model:confs}) 
          console.log confView.render().el
          $('.confList').append(confView.render().el)


      showLast: ()->

        @slides.each (slide) ->
          id = '#'+slide.id
          $(id).hide()
        lastSlide = @slides.at(@slides.length - 1)
        if lastSlide
          $('#'+lastSlide.id).show()
        if @slides.length == 0
          @slides.position = 0
        else
          @slides.position = @slides.length-1


      restore: (data)->
        $('#SlideList').children().remove()
        taille = @slides.length
        len = data.length-1
        console.log "restore la conference d'id: ", @conference
        @navigationMode = false;
        console.log @navigationMode
    
        
        if data[0]._conf != @conference || taille > data.length
          @slides.reset()
          localStorage.clear()
          @slides.fetch()
          console.log "j'ai reseté"
        
        if len >= 0
          sv = data[0]._conf
          for x in [0..len]
            obj = $.parseJSON data[x].JsonData
            slide = new Slide obj
            slide.set("conf", sv)
            slideView = new SlideView ({model : slide })
            @slides.add slide
            slide.save()
            @slides.fetch()             
      
        max = 3
        num = 0
        console.log 'taille', taille
        while (max>0 && taille>0)
          taille--
          
          
          slide = @slides.at taille
          console.log  slide.get 'conf'
          if slide.get('conf') is @conference
            slideView = new SlideView 
              model : slide
            $('#SlideList').append(slideView.render().el)
            max--
            num++
          
          switch num
            when 1 then $('.new').removeClass('new').addClass('current') 
            when 2 then $('.new').removeClass('new').addClass('past') 
            when 3 then $('.new').removeClass('new').addClass('far-past') 
        if @slides.length == 0
          @slides.position = 0
        else
          @slides.position = @slides.length-1
        $('.confBlock').fadeOut()
        $('.slides').fadeIn()
        console.log "Mode navigation?: ", @navigationMode
        console.log  "ma position: ", @slides.position
        
       
      last: ()->
        $('.new').removeClass('new').addClass('far-future')
        $('.far-future').hide()
        $('.far-future').fadeIn()
        $('.far-past').remove()
        $('.past').removeClass('past').addClass('far-past')
        $('.current').removeClass('current').addClass('past')
        $('.far-future').removeClass('far-future').addClass('current')

        #$('.far-future').removeClass('far-future').addClass('future')
        console.log  "my position ", @slides.position

      hasNext:()->
        if @slides.position <= (@slides.length-3)
          console.log "je verifie mon tableau"
          newPosSlide = @slides.position + 2 
          slide = @slides.at newPosSlide
          slideView = new SlideView 
            model : slide
          $('#SlideList').append(slideView.render().el)
          $('.new').removeClass('new').addClass('far-future') 


      hasPrevious:()->
        if @slides.position > 1
          newPosSlide = @slides.position - 2 
          slide = @slides.at newPosSlide
          slideView = new SlideView 
            model : slide
          $('#SlideList').append(slideView.render().el)
          $('.new').removeClass('new').addClass('far-past')

      setNavigationMode:()->
        if @slides.position is @slides.length-1
          @navigationMode = false
        else 
          if @slides.position < @slides.length-1 
            @navigationMode = true
        console.log "mode navigation: ", @navigationMode

        
      



        





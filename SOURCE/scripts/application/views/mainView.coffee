define [
  'jquery'
  'backbone'
  'application/views/organisationView'
  'application/views/carousel'
  ],($,Backbone,OrganisationView,Carousel)->

    class mainView extends Backbone.View
   

      el: '#header'

      initialize : ()->
        @listenTo @model, 'change:organisations', @render
        @listenTo @model, 'home', @emptyConfs
        $('#prevpage').hide()
        @offset = 0
        @on 'ServerConnection', (data)=>
          console.log "mainV connected"
          @connectNotif(data)


        $('#appcontainer').delegate '#nextpage', 'click', (e)=>
          @nextPage()
        $('#appcontainer').delegate '#prevpage', 'click', (e)=>
          @prevPage()

        $('#header').delegate '#all-shows', 'click', (e)=>

          @allShows()

        ###$('#prevpage').waypoint 
          handler:() =>
            console.log "waypoint"
          offset: '-100%'

        $('#nextpage').waypoint
          handler:() =>
            console.log "waypointnext"
          offset: '100%'###
        
        $('#appcontainer').scroll ()=>
          console.log "scroll"
          #console.log @model.allLoaded
          if $("#nextpage").offset().top+$("#nextpage").outerHeight() is $('#appcontainer').height() and @model.allLoaded
            $("#nextpage").click()




        ### $('#appcontainer').delegate '.conf-item' ,'click ', (e)=>
          txt = $(e.target).attr('id')
          @model.get('organisation').conferenceChoosed txt
          @trigger 'conferenceChoosed', txt###

        #href= 'home/'+1
        #Backbone.history.navigate(href, trigger:true)

        $('#suivant').click (e)=>
          e.preventDefault()
          @model.trigger "next"
        
        $('#precedent').click (e)=>
          e.preventDefault()
          @model.trigger "previous"

        lastTime = 0
        vendors = ["ms", "moz", "webkit", "o"]
        x = 0

        while x < vendors.length and not window.requestAnimationFrame
          window.requestAnimationFrame = window[vendors[x] + "RequestAnimationFrame"]
          window.cancelAnimationFrame = window[vendors[x] + "CancelAnimationFrame"] or window[vendors[x] + "CancelRequestAnimationFrame"]
          ++x
        unless window.requestAnimationFrame
          window.requestAnimationFrame = (callback, element) ->
            currTime = new Date().getTime()
            timeToCall = Math.max(0, 16 - (currTime - lastTime))
            id = window.setTimeout(->
              callback currTime + timeToCall
            , timeToCall)
            lastTime = currTime + timeToCall
            id
        unless window.cancelAnimationFrame
          window.cancelAnimationFrame = (id) ->
            clearTimeout id

        #@carousel = new Carousel ".slides"
        #@carousel.init()
        


      connectNotif : (data)->
        console.log "notif connected"
        $('.label').slideUp ()->
          console.log 'first'
          $('.label').removeClass('label-important').addClass('label-success')
          $('.label').text 'connected'
          console.log "seconde"
          $('.label').slideDown()

      render: ()-> 
        $('.organisation').remove()
        console.log "main view is redenring"

        @model.get('organisations').each (organisation)->
          organisationView = new OrganisationView ({model:organisation})
          $('.dropdown-menu').append(organisationView.render().el)
        $('.emissions').text $('#all-shows').text()


        $("#loading").fadeOut()
        $("#wrap").fadeIn()
        $("#header").fadeIn()

      emptyConfs:()->
        console.log "got to empty home"
        $('.conference').remove()

      nextPage:()->
        if typeof@model.get('orgChoose') is 'undefined' 
          page = @model.get 'page'
          page = page+1
          href = 'all/'+ page
          Backbone.history.navigate(href, trigger:true)
          console.log  'nextPage'
        else
          if  @model.get('orgChoose') is ' '
            page = @model.get 'page'
            page = page+1
            href = 'all/'+ page
            Backbone.history.navigate(href, trigger:true)
            console.log  href
          else 
            page = @model.get('organisations').get(@model.get('orgChoose')).get('page')
            page = page+1
            orgid = @model.get('orgChoose')
            href = 'conference/'+orgid+'/'+page
            Backbone.history.navigate(href, trigger:true)
            console.log href

      prevPage:()->
        #
      allShows:()->
        $('.emissions').text $('#all-shows').text()
        Backbone.history.navigate('home/', trigger:true)



        
            

        
        

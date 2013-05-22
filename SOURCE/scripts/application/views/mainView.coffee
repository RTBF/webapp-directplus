define [
  'jquery'
  'backbone'
  'application/views/organisationView'
  ],($,Backbone,OrganisationView)->

    class mainView extends Backbone.View
   

      el: '#header'

      template : _.template($('#app-template').html())

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

        $('#appcontainer').delegate '#all-shows', 'click', (e)=>
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
          #console.log "scrolling"
          #@offset = $(".conference:last").offset()
          #console.log "taile d'une conference:", $(".conference:last").height()
          #console.log "offset:", $(".conference:last").offset()
          console.log "offset button=", $("#nextpage").offset().top+$("#nextpage").outerHeight()
          #console.log "difference:", @offset.top-$('#appcontainer').height()
          #console.log "scroll pos:", $('#appcontainer').scrollTop()
          #console.log "scroll pos conferences", $('.conference').scrollTop()
          console.log "taille:", $('#appcontainer').height()
          #console.log "taille window:", $(window).height()

          

          
          if $("#nextpage").offset().top+$("#nextpage").outerHeight() is $('#appcontainer').height()
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
        ###if $('#header').is ':empty'
          @$el.html @template()###

        @model.get('organisations').each (organisation)->
          organisationView = new OrganisationView ({model:organisation})
          $('.dropdown-menu').append(organisationView.render().el)
        $('.emissions').text $('#all-shows').text()


        $("#loading").fadeOut()
        $("#wrap").fadeIn()

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

        
            

        
        

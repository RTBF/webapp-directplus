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
        @on 'ServerConnection', (data)=>
          console.log "mainV connected"
          @connectNotif(data)


        $('#appcontainer').delegate '#nextpage', 'click', (e)=>
          @nextPage()
          


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
            

        
        

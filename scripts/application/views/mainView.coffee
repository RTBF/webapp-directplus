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
        @on 'ServerConnection', (data)=>
          console.log "mainV connected"
          @connectNotif(data)

        $('#appcontainer').delegate '.org-item', 'click', (e)=>
          txt = $(e.target).attr('id')
          @model.organisationChoosed txt
          @trigger 'organisationChoosed', txt


        $('#appcontainer').delegate '.conf-item' ,'click ', (e)=>
          txt = $(e.target).attr('id')
          @model.get('organisation').conferenceChoosed txt
          @trigger 'conferenceChoosed', txt

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
        $('.organisationsList').children().remove()
        console.log "main view is redenring"
        ###if $('#header').is ':empty'
          @$el.html @template()###

        @model.get('organisations').each (organisation)->
          organisationView = new OrganisationView ({model:organisation})
          $('.organisationsList').append(organisationView.render().el)

        $("#loading").fadeOut()
        $("#wrap").fadeIn()
        

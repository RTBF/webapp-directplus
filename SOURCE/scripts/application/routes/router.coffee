define [
  'jquery'
  'backbone'
  'application/views/mainView'
  'application/models/app'
  ],($,Backbone,MainView,App)->
    class Router extends Backbone.Router
      routes:
        'organisation': 'organisationScreen'
        'conference/:orgid': 'conferenceScreen'
        'slides/:confid': 'slideScreen'
        # default
        
        '*actions': 'organisationScreen'

      constructor:(socket) ->
        @socket=socket
        super @routes

      initialize:()->
        @trigger 'orgRoute'
        @app = new App()

        @mainView = new MainView
          model:  @app  

        
        # Tell backbone to take care of the url navigation and history
        Backbone.history.start() #pushState: true
    
        console.log " The Route Initialized"

      organisationScreen:()->
        $('.slides').fadeOut() 
        $('.confBlock').removeClass('onshow')
        $('.organisationsBlock').addClass('onshow')
            

      conferenceScreen: (orgid)->
        console.log "emmission choosed"
        #@navigate '//lol', trigger:true

        ###$('.organisationsBlock').removeClass('onshow')
        $('.confBlock').show ()->
          $('.confBlock').addClass('onshow')###
        @socket.emit 'organisationChoosed', orgid
        ###@trigger 'confRoute', orgid
        $('.slides').fadeOut ()->
          $('.confBlock').fadeIn()###
          

      slideScreen: (confid)->
        @trigger 'slideRoute', confid
        $('.confBlock').fadeOut ()->
          $('.slides').fadeIn()

          
        
        

      
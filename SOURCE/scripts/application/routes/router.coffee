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
        'slide': 'slideScreen'
        # default
        
        '*actions': 'organisationScreen'

      constructor:() ->
        super @routes
        
        

      initialize:()->
        @trigger 'orgRoute'
        @app = new App()

        @mainView = new MainView
          model:  @app  

        @mainView.on 'organisationChoosed', (data)=>
          console.log 'router organisation choosed: ', data
          @trigger 'confRoute', data

        @mainView.on 'conferenceChoosed', (data)=>
          console.log 'router conference choosed: ', data
          @trigger 'slideRoute', data
               
        # Tell backbone to take care of the url navigation and history
        Backbone.history.start() #pushState: true
    
        console.log " The Route Initialized"

      organisationScreen:()->
        $('.slides').fadeOut() 
        $('.confBlock').removeClass('onshow')
        $('.organisationsBlock').addClass('onshow')
            

      conferenceScreen: (orgid)->
        #@navigate '//lol', trigger:true
        $('.slides').fadeOut()
        $('.organisationsBlock').removeClass('onshow')
        $('.confBlock').show ()->
          $('.confBlock').addClass('onshow')
          

      slideScreen: ()->
        $('.organisationsBlock').removeClass('onshow')
        $('.confBlock').fadeOut ()->
          $('.slides').fadeIn()
          
        
        

      
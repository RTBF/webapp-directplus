define [
  'application/config'
  'application/views/mainView'
  'application/models/app'
  'vendors/socketio/socketio'
  ],(Config, MainView,App)->
    
  ###
    Gere les communication serveur
    ###

  class Application extends Backbone.Router
    
    routes:
        'home': 'homeScreen'
        'conference/:orgid': 'conferenceScreen'
        'slides/:orgid/:confid': 'slideScreen'
        # default
        
        '*actions': 'homeScreen'

    constructor:() ->
      super @routes
      #

    initialize:() ->
      @socket = io.connect Config.serverUrl
      ###@router.on 'orgRoute', ()=>
        @connect()

      @router.on 'confRoute', (data)=>
        @socket.emit 'organisationChoosed', data
      
      @router.on 'slideRoute', (data)=>


        console.log 'app slideRoute id conf choosed: ', data
        @socket.emit 'conferenceChoosed', data###

      @app = new App()

      @mainView = new MainView
        model:  @app 
     

      @socket.on 'organisations', (data)=>
        console.log 'app organisations recieved: ', data
        @app.trigger "organisations", data

      @socket.on 'conferences', (data)=>
        console.log "app confList received", data
        @app.trigger 'conferences', data
    

      @socket.on 'allconferences', (data)=>
        console.log "app allconfList received", data
        @app.trigger 'allconferences', data
    

      @socket.on 'slides', (data)=>
        console.log 'app slides received', data
        @app.trigger 'slides', data


      @socket.on 'snext', (data) =>
        console.log "snext received"
        @app.trigger 'newSlide', data

      @socket.on 'sremove', (data)=>
        console.log "remove ask received"
        @app.trigger 'sremove', data

    
      @socket.on 'sreset', (data) =>
        console.log "reseting"
        localStorage.clear()
        $('#SlideList').empty()
        @app.trigger 'reseting', data

      @socket.on 'connect' , (data)=>
        console.log "connected"
        @mainView.trigger 'ServerConnection', data

      @socket.emit 'user', ''

      @on 'route:conferenceScreen',(orgid)=> 
        @confScreen orgid
      @on 'route:homeScreen',()=>
        @orgScreen()

      @on 'route:slideScreen', (orgid, confid)=>
        @slScreen(orgid, confid)

      
      # Tell backbone to take care of the url navigation and history
      Backbone.history.start()

      
    orgScreen:()->
      if @app.get('organisations').isEmpty()
        setTimeout ()=>
          @orgScreen()
        ,
        100
      if @app.get('organisations').isEmpty() is false 
        @app.trigger 'home'
        @connect()
        $('.slides').fadeOut ()->
          $('.confBlock').fadeIn()
          

    confScreen: (orgid)->
      @app.set 'orgChoose', orgid
      console.log "emmission choosed"
      if @app.get('organisations').isEmpty()
        setTimeout ()=>
          @confScreen(orgid)
        ,
        100
      if @app.get('organisations').isEmpty() is false 
        @socket.emit 'organisationChoosed', orgid
        @orgChoose = true
        $('.slides').fadeOut ()->
          $('.confBlock').fadeIn()
        

    slScreen: ( orgid , confid)=>
      @app.set 'orgChoose', orgid
      @app.set 'confChoose', confid
      #@trigger 'slideRoute', confid
      if @app.get('organisations').isEmpty()
        setTimeout ()=>
          @slScreen(orgid,confid)
        ,
        100

      if @app.get('organisations').isEmpty() is false 

        if typeof@orgChoose is 'undefined'

          @socket.emit 'organisationChoosed', orgid
          @orgChoose = true

        if typeof@app.get('organisations').get(orgid) is 'undefined'
          console.log 'get org id est indefini'
          setTimeout ()=>
            @slScreen(orgid,confid)
          ,
          2000
        if typeof@app.get('organisations').get(orgid) != 'undefined'
          console.log "get orgid est defini"

          if @app.get('organisations').get(orgid).get('conferencesC').isEmpty()
            console.log "la liste des conferences est vide"
            setTimeout ()=>
              @slScreen(orgid,confid)
            ,
            100

          if @app.get('organisations').get(orgid).get('conferencesC').isEmpty() is false
            console.log "je suis là"
            @socket.emit 'conferenceChoosed', confid
            $('.confBlock').fadeOut ()->
            $('.slides').fadeIn()

    connect: () -> 
      @socket.emit 'allConfs', ''
 
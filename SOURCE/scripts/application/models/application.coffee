define [
  'application/config'
  'application/routes/router'
  'application/models/slide'
  'application/collections/slides'
  'application/views/appView'
  'vendors/socketio/socketio'
  ],(Config,Router, Slide, SlidesList,AppView)->
    
  ###
    Gere les communication serveur
    ###

  class Application
  
    constructor:() ->
      @router = new Router()
      @socket = null


    init:() ->
      @socket = io.connect Config.serverUrl

      @router.on 'orgRoute', ()=>
        @connect()

      @router.on 'confRoute', (data)=>
        @socket.emit 'organisationChoosed', data
      
      @router.on 'slideRoute', (data)=>
        console.log 'app slideRoute id conf choosed: ', data
        @socket.emit 'conferenceChoosed', data

      @socket.on 'organisations', (data)=>
        console.log 'app organisations recieved: ', data
        @router.app.trigger "organisations", data

      @socket.on 'conferences', (data)=>
        console.log "app confList received", data
        @router.app.trigger 'conferences', data
    

      @socket.on 'slides', (data)=>
        console.log 'app slides received', data
        @router.app.trigger 'slides', data


      @socket.on 'snext', (data) =>
        console.log "snext received"
        @router.app.trigger 'newSlide', data

      @socket.on 'sremove', (data)=>
        console.log "remove ask received"
        @router.app.trigger 'sremove', data

    
      @socket.on 'sreset', (data) =>
        console.log "reseting"
        localStorage.clear()
        $('#SlideList').empty()
        @router.app.trigger 'reseting', data

      @socket.on 'connect' , (data)=>
        console.log "connected"
        @router.mainView.trigger 'ServerConnection', data

      @connect()


    connect: () -> 
      @socket.emit 'user', ''
 
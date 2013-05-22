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
        'all/:page': 'allScreen'
        'conference/:orgid/:page': 'conferenceScreen'
        'slides/:orgid/:confid': 'slideScreen'
        # default
        
        '*actions': 'homeScreen'

    constructor:() ->
      @HaveFirstLoad=false
      @HaveConfFirstLoad=false
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
    
      @socket.on 'allNextPage', (data, page)=>
        @app.trigger 'allNextPage', data, page

      @socket.on 'conferencesNextPage', (data, page)=>
        @app.trigger 'conferencesNextPage', data, page



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

      @on 'route:conferenceScreen',(orgid,page)=> 
        console.log "la page:", page
        @confScreen orgid, page
      
      @on 'route:homeScreen',()=>
        console.log "what?"
        @orgScreen(1)

      @on 'route:allScreen',(page)=>
        console.log "la page:", page
        @orgScreen(page)

      @on 'route:slideScreen', (orgid, confid)=>
        @slScreen(orgid, confid)

      
      # Tell backbone to take care of the url navigation and history
      Backbone.history.start()

      
    

    loadPageOneByOne:(first, end)->
      console.log 'first: ', first

      if first<=end
        if @app.loaded
          @socket.emit 'allConfs', first
          @app.loaded = false
          first= first+1
        setTimeout ()=>
          @loadPageOneByOne first, end
        ,
          100
      else
        @HaveFirstLoad=true
        @showConfs()


    loadPageOneByOneConf:(first, end, orgid)->
      console.log 'first: ', first
      console.log  'end: ', end
      console.log @app.get('organisations').get(@app.get('orgChoose')).loaded
      if first<=end
        if @app.get('organisations').get(@app.get('orgChoose')).loaded
          @socket.emit 'organisationChoosed', orgid, first
          @app.get('organisations').get(@app.get('orgChoose')).loaded = false
          first= first+1
        setTimeout ()=>
          @loadPageOneByOneConf first, end, orgid
        ,
          100
      else
        @HaveConfFirstLoad = true
        @showConfs()

    showConfs:()->
      $('.slides').fadeOut ()=>
        $('.confBlock').fadeIn()
        @app.allLoaded = true



    orgScreen:(page)->
      @app.allLoaded = false
      @HaveConfFirstLoad=false
      page = parseInt page
      console.log "hello: ", page
      @app.set 'orgChoose', ' '
      @app.set 'confChoose', ' '
      if @app.get('organisations').isEmpty()
        setTimeout ()=>
          @orgScreen(page)
        ,
        100
      if @app.get('organisations').isEmpty() is false 
        if page is 1
          @HaveFirstLoad=true
          @app.trigger 'home'
          @socket.emit 'allConfs', page
          @showConfs()

        else
          if @HaveFirstLoad is false
            @app.trigger 'home'
            @loadPageOneByOne(1, page)
          else
            @socket.emit 'allConfs', page
            @showConfs()
       
          


    confScreen: (orgid,page)->
      @app.allLoaded = false
      @HaveFirstLoad=false
      console.log page
      page = parseInt page
      @app.set 'orgChoose', orgid
      @app.set 'confChoose', ' '
      console.log "emmission choosed"
      if @app.get('organisations').isEmpty()
        setTimeout ()=>
          @confScreen(orgid, page)
        ,
        100
      if @app.get('organisations').isEmpty() is false 
        if page is 1
          @HaveConfFirstLoad = true
          @app.get('organisations').get(@app.get('orgChoose')).trigger 'empty'
          @socket.emit 'organisationChoosed', orgid, page
          @showConfs()
        else
          if @HaveConfFirstLoad is false
            @app.get('organisations').get(@app.get('orgChoose')).trigger 'empty'
            @loadPageOneByOneConf(1, page, orgid)
          else
            @socket.emit 'organisationChoosed', orgid, page
            @showConfs()
        @orgChoose = true
        
        
        

    slScreen: ( orgid , confid)=>

      @HaveConfFirstLoad=false
      @HaveFirstLoad=false
      @app.set 'orgChoose', orgid
      @app.set 'confChoose', confid
      #@trigger 'slideRoute', confid
      if @app.get('organisations').isEmpty()
        setTimeout ()=>
          @slScreen(orgid,confid)
        ,
        100

      if @app.get('organisations').isEmpty() is false 

        if typeof@orgChoosed is 'undefined'

          @socket.emit 'organisationChoosed', orgid
          @orgChoosed = true

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
 
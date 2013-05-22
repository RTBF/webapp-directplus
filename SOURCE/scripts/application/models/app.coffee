define [
  'jquery'
  'backbone'
  'application/collections/organisations'
  'application/models/organisation'
  ],($,Backbone,Organisations,Organisation)->

    class App extends Backbone.Model

      defaults:
        organisations : new Organisations()
        page: 1


      initialize : ()->

        @loaded=true

        @on 'organisations', (data)->
          @restore(data)
        @on 'conferences', (data)->
          @restoreConf data
        @on 'allconferences', (data)->
          @restoreAllConf data
        @on 'slides', (data)->
          @restoreSlides data
        @on 'newSlide', (data)->
          @get('organisations').get(@get('orgChoose')).get('conferencesC').get(@get('confChoosed')).trigger 'newSlide', data
        @on 'next', ()->
          @get('organisations').get(@get('orgChoose')).get('conferencesC').get(@get('confChoosed')).trigger 'next'
        @on 'previous', ()->
          @get('organisations').get(@get('orgChoose')).get('conferencesC').get(@get('confChoosed')).trigger 'previous'
        @on 'sremove',(data)->
          @get('organisations').get(@get('orgChoose')).get('conferencesC').get(@get('confChoosed')).trigger 'sremove', data
        @on 'allNextPage', (data, page)=>
          @allNextPage data, page
        @on 'conferencesNextPage', (data, page)=>
          @conferencesNextPage data, page



      restore:(data)->
        @get('organisations').reset()
        len = data.length - 1
        if len>=0
          for x in [0..len]
            organisation = new Organisation data[x]
            organisation.set 'id', data[x]._id
            @get('organisations').add organisation
          @trigger 'change:organisations'


        

      restoreAllConf : (data)->
        
        len = data.length - 1
        @get('organisations').each (org)=>
          org.get('conferencesC').reset()
        if len>=0
          for conf in data
            console.log conf
            @get('organisations').get(conf._orga).addConf conf
        @loaded=true
        @trigger "scroll"
            

      restoreConf : (data)->
        console.log data
        len = data.length - 1
        if len>=0
          @get('organisations').get(data[0]._orga).restore data
          @get('organisations').get(data[0]._orga).loaded = true
        @trigger "scroll"
          

      restoreSlides : (data)->
        console.log "data:", data
        len = data.length - 1
        if len>=0
          @get('organisations').get(@get('orgChoose')).get('conferencesC').get(data[0]._conf).restore data
          @set 'confChoosed', data[0]._conf
        


      organisationChoosed : (id)->
        organisationsFound = @get('organisations').where _id:id
        console.log organisationsFound[0]
        @set 'organisation', organisationsFound[0]

      allNextPage:(data, page)->
        newPage = parseInt page
        @set 'page', newPage
        for conf in data
          console.log conf
          @get('organisations').get(conf._orga).addConf conf
        if data.length > 0
          @set 'page', newPage

        @loaded=true 
          # ...
      conferencesNextPage:(data, page)->
        page  = parseInt page
        
        for conf in data
          console.log conf
          @get('organisations').get(conf._orga).addConf conf
        if data.length > 0
          @get('organisations').get(data[0]._orga).set 'page', page
          
        @get('organisations').get(@get('orgChoose')).loaded = true


     







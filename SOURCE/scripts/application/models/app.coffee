define [
  'jquery'
  'backbone'
  'application/collections/organisations'
  'application/models/organisation'
  ],($,Backbone,Organisations,Organisation)->

    class App extends Backbone.Model

      defaults:
        organisations : new Organisations()

      initialize : ()->

        @on 'organisations', (data)->
          @restore(data)
        @on 'conferences', (data)->
          @restoreConf data
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


      restore:(data)->
        @get('organisations').reset()
        len = data.length - 1
        if len>=0
          for x in [0..len]
            organisation = new Organisation data[x]
            organisation.set 'id', data[x]._id
            @get('organisations').add organisation
          @trigger 'change:organisations'
          @trigger 'initialized'
        

      restoreConf : (data)->
        console.log data
        len = data.length - 1

        if len>=0
          @get('organisations').get(data[0]._orga).restore data
          @set('orgChoose', data[0]._orga)


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



     







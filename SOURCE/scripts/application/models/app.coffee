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
          @get('organisation').get('conference').trigger 'newSlide', data
        @on 'next', ()->
          @get('organisation').get('conference').trigger 'next'
        @on 'previous', ()->
          @get('organisation').get('conference').trigger 'previous'
        @on 'sremove',(data)->
          @get('organisation').get('conference').trigger 'sremove', data


      restore:(data)->
        @get('organisations').reset()
        len = data.length - 1
        if len>=0
          for x in [0..len]
            organisation = new Organisation data[x]
            @get('organisations').add organisation
          @trigger 'change:organisations'
          console.log @get 'organisations'

      restoreConf : (data)->
        console.log data
        len = data.length - 1

        if len>=0
          @get('organisation').restore data


      restoreSlides : (data)->
        console.log data
        len = data.length - 1
        if len>=0
          @get('organisation').get('conference').restore data


      organisationChoosed : (id)->
        organisationsFound = @get('organisations').where _id:id
        console.log organisationsFound[0]
        @set 'organisation', organisationsFound[0]



     







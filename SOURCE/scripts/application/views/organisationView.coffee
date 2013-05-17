define [
  'jquery'
  'backbone'
  'application/views/conferenceView'
  ],($,Backbone,ConferenceView)->

    class OrganisationView extends Backbone.View

      #el: '#appcontainer'

      tagName : 'li'
      className : 'organisation '
      
      events:
        'click .org-item' : 'choose'


      template : _.template($('#Organisation-template').html())

      initialize : ()->
        @listenTo @model, 'change:conferencesC', @renderConfList
       

      render: ()-> 
        @$el.html @template(@model.toJSON())
        @
        
      renderConfList:()->
        $('.conference').remove()
        @model.get('conferencesC').each (conference)->
          conferenceView = new ConferenceView ({model:conference})
          $('.conferenceList').append(conferenceView.render().el)
        @

      choose:(ev)->
        #
        
        id = @model.get 'id'
        href =  '/conference/' + id
        console.log href
        Backbone.history.navigate(href, trigger:true)



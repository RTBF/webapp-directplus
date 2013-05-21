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
        @listenTo @model, 'empty', @emptyConfs
        @listenTo @model, 'addConf', (id)=>
          @renderAdd id
       

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
        id = @model.get 'id'
        href =  '/conference/' + id+'/'+1
        console.log href
        $('.conference').remove()
        Backbone.history.navigate(href, trigger:true)

      renderAdd:(id)->
        console.log id
        conference = @model.get('conferencesC').get(id)
        conferenceView = new ConferenceView {model:conference}
        console.log "confView: ", conferenceView
        $('.conferenceList').append(conferenceView.render().el)
        @

      emptyConfs:()->
        console.log "got to empty home"
        $('.conference').remove()




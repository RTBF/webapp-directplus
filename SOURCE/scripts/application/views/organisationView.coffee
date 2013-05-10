define [
  'jquery'
  'backbone'
  'application/views/conferenceView'
  ],($,Backbone,ConferenceView)->

    class OrganisationView extends Backbone.View

      #el: '#appcontainer'

      tagName : 'li'
      className : 'organisation'
      
      events:
        'click .org-item' : 'choose'


      template : _.template($('#Organisation-template').html())

      initialize : ()->
        @listenTo @model, 'change:conferencesC', @render
       

      render: ()-> 
        $('.confList').children().remove()
        console.log "Je suis lorganisation et je me renderer"
        @$el.html @template(@model.toJSON())
        @model.get('conferencesC').each (conference)->
          conferenceView = new ConferenceView ({model:conference})
          $('.confList').append(conferenceView.render().el)
        @
      
      choose:(ev)->
        #
        console.log ev.target
        id = $(ev.target).attr('id')
        Backbone.history.navigate('/conference/orgid' , trigger:true)




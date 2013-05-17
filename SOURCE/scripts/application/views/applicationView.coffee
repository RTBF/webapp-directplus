define [
  'jquery'
  'backbone'
  'application/models/slide'
  'application/views/slideScreen'
  'application/collections/Organisations'
  'application/models/organisation'
  'application/views/organisationView'
  'application/models/conference'
  'application/views/conferenceView'
  ],($,Backbone,Slide,SlideView,Organisations,Organisation,OrganisationView,Conference, ConferenceView)->

   

    class appView extends Backbone.View
   

      el: '#header'

      template : _.template($('#app-template').html())

      initialize : ()->
        @organisations = new Organisations()
        @organisations.fetch()
        @render()
        @on 'ServerConnection' , (data)=>
          @connectNotif data
        @on 'organisations', (data)=>
          @fullFillOrgList data
        console.log "appView built"


      connectNotif : (data)->
        $('.js-status').removeClass('disconnected').addClass('connected')

      render: ()-> 
        @$el.html @template()
        #@

      fullFillOrgList: (data)->
        $(".organisation").remove()
        len = data.length - 1
        console.log len
        for x in [0..len]
          organisation = new Organisation data[x]
          console.log organisation
          organisationView = new OrganisationView ({model:organisation})
          $('.dropdown-menu').append(organisationView.render().el)
        
        $("#loading").fadeOut()
        $("#wrap").fadeIn()

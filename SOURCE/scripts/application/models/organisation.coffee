define [
  'jquery'
  'backbone'
  'application/models/conference'
  'application/collections/conferences'
  ],($,Backbone,Conference,Conferences)->

    class Organisation extends Backbone.Model

      defaults:
        name: ' '
        tumb: ' '
        description: ' '
        conferencesC: new Conferences()

     
      constructor: (aOrg)->
        super aOrg
         # ...

      initialize:()->
        @on 'conferences', (data)->
          @restore data

      restore:(data)->
        @get('conferencesC').reset()
        len = data.length - 1
        for x in [0..len]
          conference = new Conference data[x]
          @get('conferencesC').add conference
        @trigger 'change:conferencesC'

      conferenceChoosed:(id)->
        confsFound = @get('conferencesC').where _id:id
        @set 'conference', confsFound[0]
        
     



  

   
  

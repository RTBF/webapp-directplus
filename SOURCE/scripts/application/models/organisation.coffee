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
        page:1
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
          conference.set 'id', data[x]._id
          conference.set 'orgName', @get 'name'
          date= new Date conference.get('date')
          conference.set 'datestring', date.toLocaleString()
          @get('conferencesC').add conference
        @trigger 'change:conferencesC'

      conferenceChoosed:(id)->
        confsFound = @get('conferencesC').where _id:id
        @set 'conference', confsFound[0]

      addConf:(conf)->
        conference = new Conference conf
        conference.set 'id', conf._id
        conference.set 'orgName', @get 'name'
        date= new Date conference.get('date')
        conference.set 'datestring', date.toLocaleString()
        @get('conferencesC').add conference
        console.log @get('conferencesC')
        @trigger 'addConf', conf._id

        
     



  

   
  

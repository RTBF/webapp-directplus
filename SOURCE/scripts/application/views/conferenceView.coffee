define [
  'jquery'
  'backbone'
  'application/views/slideScreen'
  ],($,Backbone,SlideView)->

    class ConferenceView extends Backbone.View

      #el: '#appcontainer'
      
      tagName : 'li'
      className : 'conference'

      template : _.template($('#conf-template').html())
      events:
        'click .conf-item ':'choose'


      initialize : ()->
       @listenTo @model, 'change:slidesC', @render
       @listenTo @model, 'new', @new
      

      render: ()-> 
        console.log "confView"
        @$el.html @template(@model.toJSON())
        console.log @model.toJSON()
        @setCountDown()
        $('#SlideList').children().remove()
        if $('#SlideList').is ':empty'
          @model.get('slidesC').each (slide)->
            console.log slide
            console.log slide.get('state')
            slideView = new SlideView 
              model : slide
            slideView.render()
        @

      new:()->
        console.log "render new"
        slide = @model.get('slidesC').at @model.get('slidesC').length - 1
        slideView = new SlideView 
          model : slide
        slide = @model.get('slidesC').where state:'future'
        if slide[0]
          slideView.render()
        else
          console.log "future doesn't exist"
          slideView.new()
      
      choose:()->
        console.log @model
        confid = @model.get 'id'
        orgid = @model.get '_orga'
        href =  '/slides/'+orgid+'/'+confid
        $(".slide").remove()
        Backbone.history.navigate(href, trigger:true)

      setCountDown:()->
        id = '#'+@model.get('id')
        timer= '#'+@model.get('id')+' .timer'
        img = '#'+@model.get('id')+' .play img'
        directDate = new Date @model.get('date')
        today = new Date()
        intervalmilliseconde = directDate.getTime()-today.getTime()
        
        if intervalmilliseconde > 0
          $(timer).html(@getIntervalTimer(intervalmilliseconde))
          setTimeout ()=>
            @setCountDown()
          ,
            998
        else
          console.log $(timer).html()
          if typeof($(timer).html()) is 'undefined'
            setTimeout ()=>
              @setCountDown()
            ,
              998
          else
            $(timer).text("REVOIR")
            $(img).attr 'src', 'http://projet.local.rtbf.be/RTBF/webapp-directplus/SOURCE/skins/images/pictosplayed.png'
            elt = $(id).parent()

            console.log "index: ", $('li.conference').index(elt)
            value =$('.conferenceList  .conference').first().height() * ($('.conferenceList .conference').index(elt)+1)
            $('#appcontainer').scrollTop(value)

      
      getIntervalTimer:(intervalmilliseconde)->
        day = parseInt intervalmilliseconde / (1000*60*60*24)
        intervalmilliseconde = intervalmilliseconde - (day*1000*60*60*24)
        hours = parseInt intervalmilliseconde / (1000*60*60)
        intervalmilliseconde = intervalmilliseconde - (hours*1000*60*60)
        minutes = parseInt intervalmilliseconde / (1000*60)
        intervalmilliseconde = intervalmilliseconde - (minutes*1000*60)
        secondes = parseInt intervalmilliseconde / (1000)

        interval= day+" DAYS "+"<br/>"+hours+":"+minutes+":"+secondes
        interval


        





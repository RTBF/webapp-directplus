define ['jquery'],($)->

  describe "As a user I want to watch the conference in real time", ()->
    describe "test that the connection is established", ()->
      it "should connect to the server", ()->
        connected = false
        testConnected = ->
          connected = $('.js-status').hasClass('connected')

        waitsFor testConnected , "The connection should be established" , 1000
          

        expect(connected).toBe(true)
    describe "test that a data received is a slide",()->
define ["jquery","jasmine-html"], ($,jasmine)->
  class Test
    constructor:()->

    init:()->
      jasmineEnv = jasmine.getEnv()
      jasmineEnv.updateInterval = 250
      htmlReporter = new jasmine.HtmlReporter()
      jasmineEnv.addReporter(htmlReporter)

      jasmineEnv.specFilter = (spec) ->
        return htmlReporter.specFilter(spec)

      specs = []
      specs.push('../../TEST/scripts/specs/seeConference')
      specs.push('../../TEST/scripts/specs/nextPrevious')

      $(()->
        require specs,()->
          jasmineEnv.execute()
      )


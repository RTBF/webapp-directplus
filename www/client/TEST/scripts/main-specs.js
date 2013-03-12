// Generated by CoffeeScript 1.4.0

requirejs.config({
  baseUrl: '../SOURCE/scripts',
  paths: {
    jquery: 'vendors/jquery/jquery',
    underscore: 'vendors/underscore/underscore',
    backbone: 'vendors/backbone/backbone',
    backbonels: 'vendors/backbone/backbone.localStorage',
    bootstrap: 'vendors/bootstrap/bootstrap',
    jasmine: 'vendors/jasmine/jasmine',
    'jasmine-html': 'vendors/jasmine/jasmine-html',
    text: 'vendors/require/text'
  },
  shim: {
    backbone: {
      deps: ['jquery', 'underscore'],
      exports: 'Backbone'
    },
    underscore: {
      exports: '_'
    },
    bootstrap: {
      deps: ['jquery']
    },
    jasmine: {
      exports: 'jasmine'
    },
    'jasmine-html': {
      deps: ['jasmine'],
      exports: 'jasmine'
    }
  },
  wait: '5s'
});

require(['backbone', 'backbonels', 'jquery', 'application/models/application', '../../TEST/scripts/specs/test', 'bootstrap'], function(Backbone, Backbonels, $, App, Test) {
  return $(function() {
    App = new App();
    App.init();
    console.log("launched");
    Test = new Test();
    Test.init();
    return console.log('test launched');
  });
});
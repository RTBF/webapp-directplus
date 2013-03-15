// Generated by CoffeeScript 1.4.0
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(['jquery', 'backbone', 'application/models/slide', 'application/views/slideScreen', 'application/collections/slides'], function($, Backbone, Slide, SlideView, Slides) {
  var appView;
  return appView = (function(_super) {

    __extends(appView, _super);

    function appView() {
      return appView.__super__.constructor.apply(this, arguments);
    }

    appView.slides = new Slides();

    appView.prototype.el = '#header';

    appView.prototype.template = _.template($('#app-template').html());

    appView.prototype.events = {
      'click #previous': 'previous',
      'click #next': 'next'
    };

    appView.prototype.initialize = function() {
      var _this = this;
      this.render();
      this.on('newSlide', function(data) {
        return _this.newSlide(data);
      });
      this.on('ServerConnection', function(data) {
        return _this.connectNotif(data);
      });
      appView.slides.fetch();
      return this.restore();
    };

    appView.prototype.connectNotif = function(data) {
      return $('.js-status').removeClass('disconnected').addClass('connected');
    };

    appView.prototype.render = function() {
      this.$el.html(this.template());
      return this;
    };

    appView.prototype.previous = function() {
      var current, previous;
      if (appView.slides.position > 0) {
        current = appView.slides.at(appView.slides.position);
        $('#' + current.id).hide();
        appView.slides.position = appView.slides.position - 1;
        previous = appView.slides.at(appView.slides.position);
        $('#' + previous.id).show();
        return console.log('previous man');
      }
    };

    appView.prototype.next = function() {
      var current, previous;
      if (appView.slides.position < (appView.slides.length - 1)) {
        current = appView.slides.at(appView.slides.position);
        $('#' + current.id).hide();
        appView.slides.position = appView.slides.position + 1;
        previous = appView.slides.at(appView.slides.position);
        $('#' + previous.id).show();
        return console.log('next man');
      }
    };

    appView.prototype.newSlide = function(data) {
      var slide, slideView;
      slide = new Slide(data);
      slideView = new SlideView({
        model: slide
      });
      appView.slides.add(slide);
      slide.save();
      appView.slides.fetch();
      $('#SlideList').append(slideView.render().el);
      return this.showLast();
    };

    appView.prototype.showLast = function() {
      var lastSlide;
      appView.slides.each(function(slide) {
        return $('#' + slide.id).hide();
      });
      lastSlide = appView.slides.at(appView.slides.length - 1);
      if (lastSlide) {
        $('#' + lastSlide.id).show();
      }
      return appView.slides.position = appView.slides.length - 1;
    };

    appView.prototype.restore = function() {
      var _this = this;
      console.log("SO WHAT");
      appView.slides.each(function(slide) {
        var slideView;
        slideView = new SlideView({
          model: slide
        });
        return $('#SlideList').append(slideView.render().el);
      });
      return this.showLast();
    };

    return appView;

  })(Backbone.View);
});
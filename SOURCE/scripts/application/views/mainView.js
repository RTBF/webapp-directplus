// Generated by CoffeeScript 1.4.0
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(['jquery', 'backbone', 'application/views/organisationView'], function($, Backbone, OrganisationView) {
  var mainView;
  return mainView = (function(_super) {

    __extends(mainView, _super);

    function mainView() {
      return mainView.__super__.constructor.apply(this, arguments);
    }

    mainView.prototype.el = '#header';

    mainView.prototype.template = _.template($('#app-template').html());

    mainView.prototype.initialize = function() {
      var _this = this;
      this.listenTo(this.model, 'change:organisations', this.render);
      this.on('ServerConnection', function(data) {
        console.log("mainV connected");
        return _this.connectNotif(data);
      });
      /*$('#appcontainer').delegate '.org-item', 'click', (e)=>
        txt = $(e.target).attr('id')
        @model.organisationChoosed txt
        @trigger 'organisationChoosed', txt
      */

      $('#appcontainer').delegate('.conf-item', 'click ', function(e) {
        var txt;
        txt = $(e.target).attr('id');
        _this.model.get('organisation').conferenceChoosed(txt);
        return _this.trigger('conferenceChoosed', txt);
      });
      $('#suivant').click(function(e) {
        e.preventDefault();
        return _this.model.trigger("next");
      });
      return $('#precedent').click(function(e) {
        e.preventDefault();
        return _this.model.trigger("previous");
      });
    };

    mainView.prototype.connectNotif = function(data) {
      console.log("notif connected");
      return $('.label').slideUp(function() {
        console.log('first');
        $('.label').removeClass('label-important').addClass('label-success');
        $('.label').text('connected');
        console.log("seconde");
        return $('.label').slideDown();
      });
    };

    mainView.prototype.render = function() {
      $('.organisation').remove();
      console.log("main view is redenring");
      /*if $('#header').is ':empty'
        @$el.html @template()
      */

      this.model.get('organisations').each(function(organisation) {
        var organisationView;
        organisationView = new OrganisationView({
          model: organisation
        });
        return $('.dropdown-menu').append(organisationView.render().el);
      });
      $('.emissions').text($('#all-shows').text());
      $("#loading").fadeOut();
      return $("#wrap").fadeIn();
    };

    return mainView;

  })(Backbone.View);
});

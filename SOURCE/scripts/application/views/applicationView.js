// Generated by CoffeeScript 1.6.2
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(['jquery', 'backbone', 'application/models/slide', 'application/views/slideScreen', 'application/collections/Organisations', 'application/models/organisation', 'application/views/organisationView', 'application/models/conference', 'application/views/conferenceView'], function($, Backbone, Slide, SlideView, Organisations, Organisation, OrganisationView, Conference, ConferenceView) {
  var appView, _ref;

  return appView = (function(_super) {
    __extends(appView, _super);

    function appView() {
      _ref = appView.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    appView.prototype.el = '#header';

    appView.prototype.initialize = function() {
      var _this = this;

      this.organisations = new Organisations();
      this.organisations.fetch();
      this.render();
      this.on('ServerConnection', function(data) {
        return _this.connectNotif(data);
      });
      this.on('organisations', function(data) {
        return _this.fullFillOrgList(data);
      });
      return console.log("appView built");
    };

    appView.prototype.connectNotif = function(data) {
      return $('.js-status').removeClass('disconnected').addClass('connected');
    };

    appView.prototype.render = function() {};

    appView.prototype.fullFillOrgList = function(data) {
      var len, organisation, organisationView, x, _i;

      $(".organisation").remove();
      len = data.length - 1;
      console.log(len);
      for (x = _i = 0; 0 <= len ? _i <= len : _i >= len; x = 0 <= len ? ++_i : --_i) {
        organisation = new Organisation(data[x]);
        console.log(organisation);
        organisationView = new OrganisationView({
          model: organisation
        });
        $('.dropdown-menu').append(organisationView.render().el);
      }
      $("#loading").fadeOut();
      return $("#wrap").fadeIn();
    };

    return appView;

  })(Backbone.View);
});

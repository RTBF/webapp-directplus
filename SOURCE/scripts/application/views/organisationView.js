// Generated by CoffeeScript 1.4.0
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(['jquery', 'backbone', 'application/views/conferenceView'], function($, Backbone, ConferenceView) {
  var OrganisationView;
  return OrganisationView = (function(_super) {

    __extends(OrganisationView, _super);

    function OrganisationView() {
      return OrganisationView.__super__.constructor.apply(this, arguments);
    }

    OrganisationView.prototype.tagName = 'li';

    OrganisationView.prototype.className = 'organisation ';

    OrganisationView.prototype.events = {
      'click .org-item': 'choose'
    };

    OrganisationView.prototype.template = _.template($('#Organisation-template').html());

    OrganisationView.prototype.initialize = function() {
      var _this = this;
      this.listenTo(this.model, 'change:conferencesC', this.renderConfList);
      this.listenTo(this.model, 'empty', this.emptyConfs);
      return this.listenTo(this.model, 'addConf', function(id) {
        return _this.renderAdd(id);
      });
    };

    OrganisationView.prototype.render = function() {
      this.$el.html(this.template(this.model.toJSON()));
      return this;
    };

    OrganisationView.prototype.renderConfList = function() {
      $('.conference').remove();
      this.model.get('conferencesC').each(function(conference) {
        var conferenceView;
        conferenceView = new ConferenceView({
          model: conference
        });
        return $('.conferenceList').append(conferenceView.render().el);
      });
      return this;
    };

    OrganisationView.prototype.choose = function(ev) {
      var href, id;
      id = this.model.get('id');
      href = '/conference/' + id + '/' + 1;
      console.log(href);
      $('.conference').remove();
      return Backbone.history.navigate(href, {
        trigger: true
      });
    };

    OrganisationView.prototype.renderAdd = function(id) {
      var conference, conferenceView;
      console.log(id);
      conference = this.model.get('conferencesC').get(id);
      conferenceView = new ConferenceView({
        model: conference
      });
      console.log("confView: ", conferenceView);
      $('.conferenceList').append(conferenceView.render().el);
      return this;
    };

    OrganisationView.prototype.emptyConfs = function() {
      console.log("got to empty home");
      return $('.conference').remove();
    };

    return OrganisationView;

  })(Backbone.View);
});

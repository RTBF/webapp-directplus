// Generated by CoffeeScript 1.4.0
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(['jquery', 'backbone', 'application/models/conference', 'application/collections/conferences'], function($, Backbone, Conference, Conferences) {
  var Organisation;
  return Organisation = (function(_super) {

    __extends(Organisation, _super);

    Organisation.prototype.defaults = {
      name: ' ',
      tumb: ' ',
      description: ' ',
      conferencesC: new Conferences()
    };

    function Organisation(aOrg) {
      Organisation.__super__.constructor.call(this, aOrg);
    }

    Organisation.prototype.initialize = function() {
      return this.on('conferences', function(data) {
        return this.restore(data);
      });
    };

    Organisation.prototype.restore = function(data) {
      var conference, len, x, _i;
      this.get('conferencesC').reset();
      len = data.length - 1;
      for (x = _i = 0; 0 <= len ? _i <= len : _i >= len; x = 0 <= len ? ++_i : --_i) {
        conference = new Conference(data[x]);
        conference.set('id', data[x]._id);
        conference.set('orgName', this.get('name'));
        this.get('conferencesC').add(conference);
      }
      return this.trigger('change:conferencesC');
    };

    Organisation.prototype.conferenceChoosed = function(id) {
      var confsFound;
      confsFound = this.get('conferencesC').where({
        _id: id
      });
      return this.set('conference', confsFound[0]);
    };

    return Organisation;

  })(Backbone.Model);
});

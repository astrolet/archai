(function() {
  var Backbone, Point, Points, coordinates, _,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  _ = require('underscore');

  Backbone = require('backbone');

  coordinates = require('./coordinates');

  Point = (function(_super) {

    __extends(Point, _super);

    function Point() {
      Point.__super__.constructor.apply(this, arguments);
    }

    Point.prototype.initialize = function(attributes) {
      if (attributes.lon == null) attributes.lon = 0;
      this.at = coordinates.of(attributes.lon, attributes.lat);
      if (attributes.lat == null) attributes.lat = this.at.lat.dec;
      if (attributes.timeshift == null) attributes.timeshift = null;
      if (attributes.reason == null) attributes.reason = null;
      return this.set(attributes);
    };

    return Point;

  })(Backbone.Model);

  Points = (function(_super) {

    __extends(Points, _super);

    function Points() {
      Points.__super__.constructor.apply(this, arguments);
    }

    Points.prototype.model = Point;

    Points.prototype.a = function() {
      var _ref;
      return (_ref = this.at(0)) != null ? _ref : new Point({
        id: '-'
      });
    };

    return Points;

  })(Backbone.Collection);

  module.exports = Points;

}).call(this);

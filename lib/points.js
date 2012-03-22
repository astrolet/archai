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

    Point.prototype.atCoordinates = function(lon, lat) {
      var _ref, _ref2;
      if (lon == null) lon = 0;
      this.at = coordinates.of((_ref = this.get("lon")) != null ? _ref : lon, (_ref2 = this.get("lat")) != null ? _ref2 : lat);
      return this.at.ecliptical('dec');
    };

    Point.prototype.initialize = function(a) {
      var _ref;
      _ref = this.atCoordinates(a.lon, a.lat), a.lon = _ref[0], a.lat = _ref[1];
      if (a.timeshift == null) a.timeshift = null;
      if (a.reason == null) a.reason = null;
      this.set(a);
      this.bind("change:lon", this.atCoordinates);
      return this.bind("change:lat", this.atCoordinates);
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

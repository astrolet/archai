(function() {
  var CelestialCoordinates, Coordinates, degrees, _,
    __slice = Array.prototype.slice;

  _ = require('underscore');

  degrees = require('./degrees');

  Coordinates = (function() {

    function Coordinates() {}

    Coordinates.prototype.of = function(x, y) {
      var _ref;
      if (y == null) y = 0;
      if (((x != null ? x.lon : void 0) != null) && ((x != null ? x.lat : void 0) != null)) {
        _ref = [x.lon, x.lat], x = _ref[0], y = _ref[1];
      }
      return new CelestialCoordinates(x, y);
    };

    Coordinates.prototype.geo = function(x, y) {
      throw "To become geo coordinates (Gaia replacement), later on...";
    };

    return Coordinates;

  })();

  CelestialCoordinates = (function() {

    function CelestialCoordinates(lon, lat) {
      this.lon = degrees.of(lon, 'longitude');
      this.lat = degrees.of(lat);
    }

    CelestialCoordinates.prototype.ecliptical = function() {
      var r, rest;
      r = arguments[0], rest = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      if (r != null) {
        return [_.result(this.lon, r), _.result(this.lat, r)];
      } else {
        return [this.lon, this.lat];
      }
    };

    return CelestialCoordinates;

  })();

  module.exports = new Coordinates;

}).call(this);

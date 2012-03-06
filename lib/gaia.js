(function() {
  var Gaia, Geo, LatLon, ut, _;

  ut = require("./ut");

  _ = require("massagist")._;

  Geo = require("geoutils").Geo;

  LatLon = require("geoutils").LatLon;

  Gaia = (function() {

    Gaia.prototype.pinpoint = function(where) {
      var _ref;
      if (where instanceof String) {
        _ref = where.split(","), this.lat = _ref[0], this.lon = _ref[1];
        return where;
      } else if (where instanceof Object) {
        if ((where.lat != null) && (where.lon != null)) {
          this.lat = where.lat;
          this.lon = where.lon;
        } else {
          this.lat = NaN;
          this.lon = NaN;
        }
        return "" + this.lat + "," + this.lon;
      } else {
        return console.log("Unexpected kind of where: " + where);
      }
    };

    Gaia.prototype.timezone = function(at) {
      return "+02:00";
    };

    function Gaia(where, moment) {
      var offset, time;
      this.at = this.pinpoint(where);
      this.tz = this.timezone(this.at);
      if (moment != null) {
        if (!ut.isoMatchFormat(moment)) {
          console.log("Invalid date-time format of: " + moment);
          return;
        }
        time = moment;
      } else {
        time = (new Date((new Date(Date.now())).toUTCString())).toISOString();
      }
      if (_.endsWith(time, "Z")) {} else if (offset = ut.isoMatchOffset(time)) {
        offset = offset.toString();
        if (offset !== this.tz) {
          console.log("Correcting timezone from " + offset + " to " + this.tz);
          time = time.replace(offset, this.tz);
        }
      } else {
        time += this.tz;
      }
      this.iso = time;
      this.time = new Date(time);
      this.utc = this.time.toISOString();
      this.ut = ut.c(this.utc);
    }

    return Gaia;

  })();

  module.exports = Gaia;

}).call(this);

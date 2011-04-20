(function() {
  var Gaia, Geo, LatLon, _;
  _ = require("massagist")._;
  Geo = require("geoutils").Geo;
  LatLon = require("geoutils").LatLon;
  Gaia = (function() {
    Gaia.prototype.iso8601Offset = /[-+]\d{2}:\d{2}$/;
    Gaia.prototype.iso8601Format = /^(\d{4})-(\d{2})-(\d{2})((([T ](\d{2}):(\d{2})(:(\d{2})(\.(\d+))?)?)?)?)?(([-+])(\d{2}):(\d{2}))?(Z)?$/;
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
      var offset, t, time;
      this.at = this.pinpoint(where);
      this.tz = this.timezone(this.at);
      if (moment != null) {
        if (!moment.match(this.iso8601Format)) {
          console.log("Invalid date-time format of: " + moment);
          return;
        }
        time = moment;
      } else {
        time = (new Date((new Date(Date.now())).toUTCString())).toISOString();
      }
      if (_.endsWith(time, "Z")) {} else if (offset = time.match(this.iso8601Offset)) {
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
      /*
      @ut = [ @time.getUTCFullYear()
            , @time.getUTCMonth()
            , @time.getUTCDate()
            , @time.getUTCHours()
            , @time.getUTCMinutes()
            , "#{@time.getUTCSeconds()}.#{@time.getUTCMilliseconds()}"
            ]
      */
      t = this.utc.match(this.iso8601Format);
      this.ut = [Number(t[1]), Number(t[2]), Number(t[3]), Number(t[7]), Number(t[8]), Number("" + t[10] + "." + t[12])];
      /*
      console.log "@iso: #{@iso}"
      console.log "@time: #{@time}"
      console.log "@utc: #{@utc}"

      @date = new Date @time
      console.log "getTimezoneOffset() = #{@date.getTimezoneOffset() / 60}"
      console.log "toString: #{@date.toString()}"
      console.log "toUTCString: #{@date.toUTCString()}"
      console.log "toISOString: #{@date.toISOString()}"
      */
    }
    return Gaia;
  })();
  module.exports = Gaia;
}).call(this);

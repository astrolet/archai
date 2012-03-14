(function() {
  var CelestialLongitude, Degrees, DegreesBase, degrees, _,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  _ = require('underscore');

  Degrees = (function() {

    function Degrees() {}

    Degrees.prototype.of = function(given, base) {
      if (base == null) base = true;
      switch (base) {
        case true:
          return new DegreesBase(given);
        case 'lon':
        case 'longitude':
          return new CelestialLongitude(given);
        default:
          throw "Unknown kind of " + base + " degrees.";
      }
    };

    Degrees.prototype.lon = function(given, rep) {
      var add;
      if (rep != null) {
        if (_.isNumber(rep) && (1 <= rep && rep <= 12)) {
          rep = Math.floor(rep);
          add = (rep - 1) * 30;
          if (_.isNumber(given)) {
            given += add;
          } else if (_.isArray(given && _.isNumber(given[0]))) {
            given[0] += add;
          } else {
            throw "The given " + given + " degrees can't be added to.";
          }
        } else {
          throw "Invalid representation " + rep + ".";
        }
      }
      return this.of(given, 'lon');
    };

    return Degrees;

  })();

  degrees = new Degrees;

  DegreesBase = (function() {

    DegreesBase.prototype.dec = NaN;

    DegreesBase.prototype.abs = false;

    function DegreesBase(given) {
      var _ref;
      this.given = given;
      if (_.isNumber(this.given)) {
        this.dec = this.given;
      } else if (_.isArray(this.given)) {
        if (!((1 <= (_ref = this.given.length) && _ref <= 3))) {
          throw "The given array must at least have degrees, and at most seconds.";
        }
        this.dec = Math.floor(Math.abs(this.given[0]));
        if (this.given.length > 1) {
          this.dec += Math.floor(Math.abs(this.given[1])) / 60;
        }
        if (this.given.length > 2) {
          this.dec += Math.floor(Math.abs(this.given[2])) / 3600;
        }
      } else {
        throw "Unexpected '" + (typeof this.given) + "' type of degrees given.";
      }
      if (this.abs) this.dec = Math.abs(this.dec);
    }

    DegreesBase.prototype.neg = function() {
      if (!this.abs) this.dec = 0 - Math.abs(this.dec);
      return this;
    };

    DegreesBase.prototype.the = function() {
      return this.dec;
    };

    DegreesBase.prototype.rad = function() {
      return this.dec * Math.PI / 180;
    };

    DegreesBase.prototype.dms = function() {
      var d, dec, m, n, s;
      n = this.dec < 0 ? '-' : '';
      dec = Math.abs(this.dec);
      d = Math.floor(dec);
      m = Math.floor((dec * 60) % 60);
      s = Math.floor((dec * 3600) % 60);
      return [n, d, m, s];
    };

    DegreesBase.prototype.str = function() {
      var d, m, n, s, _ref;
      _ref = this.dms(), n = _ref[0], d = _ref[1], m = _ref[2], s = _ref[3];
      return "" + n + d + "\u00B0" + m + "\u2032" + s + "\u2033";
    };

    DegreesBase.prototype.unimplemented = function(method) {
      throw "The wanted '" + method + "' method is not implemented yet.";
    };

    return DegreesBase;

  })();

  CelestialLongitude = (function(_super) {

    __extends(CelestialLongitude, _super);

    CelestialLongitude.prototype.abs = true;

    CelestialLongitude.prototype.aligns = false;

    CelestialLongitude.prototype.representations = ['♈', '♉', '♊', '♋', '♌', '♍', '♎', '♏', '♐', '♑', '♒', '♓'];

    function CelestialLongitude(given) {
      this.given = given;
      CelestialLongitude.__super__.constructor.call(this, this.given);
      this.dec %= 360;
      if (this.dec === 0) this.dec = 360;
    }

    CelestialLongitude.prototype.align = function(fill) {
      if (fill == null) fill = ' ';
      if (_.isNumber(fill)) fill = "" + fill;
      this.aligns = fill;
      return this;
    };

    CelestialLongitude.prototype.dms = function() {
      var d, m, n, s, _ref;
      _ref = CelestialLongitude.__super__.dms.call(this), n = _ref[0], d = _ref[1], m = _ref[2], s = _ref[3];
      if (_.isString(this.aligns)) {
        if (this.aligns.length > 1) this.aligns = this.aligns.charAt(0);
        if (d < 10) d = "" + this.aligns + d;
        if (m < 10) m = "" + this.aligns + m;
        if (s < 10) s = "" + this.aligns + s;
      }
      this.aligns = false;
      return [d, m, s];
    };

    CelestialLongitude.prototype.top = function() {
      var portion;
      portion = Math.ceil(this.dec);
      if (portion === 0) portion = 360;
      return portion;
    };

    CelestialLongitude.prototype.portion = function() {
      return this.top();
    };

    CelestialLongitude.prototype.rep = function(more) {
      var a, d, m, rep, rest, s, _ref, _ref2;
      rep = this.dec === 0 || this.dec === 360 ? 12 : Math.ceil(this.dec / 30);
      switch (more) {
        case void 0:
          return rep;
        case "sym":
          return this.representations[rep - 1];
        case "str":
          rest = this.dec - (rep - 1) * 30;
          _ref = [(_.isString(this.aligns) ? this.aligns : null), false], a = _ref[0], this.aligns = _ref[1];
          _ref2 = degrees.lon(rest).align(a).dms(), d = _ref2[0], m = _ref2[1], s = _ref2[2];
          return "" + this.representations[rep - 1] + "  " + d + "\u00B0" + m + "\u2032" + s + "\u2033";
        case "the":
        case "top":
          return [rep, this[more]() - (rep - 1) * 30];
        default:
          throw "Unsupported: rep('" + more + "')";
      }
    };

    CelestialLongitude.prototype.representation = function(more) {
      return this.rep(more);
    };

    CelestialLongitude.prototype._12 = function(exact) {
      if (exact == null) exact = false;
      return this.unimplemented('p12');
    };

    return CelestialLongitude;

  })(DegreesBase);

  module.exports = degrees;

}).call(this);

(function() {
  var Backbone, Point, Points, coordinates, ensemble, _,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  _ = require('underscore');

  Backbone = require('backbone');

  coordinates = require('./coordinates');

  ensemble = new (require('./ensemble'));

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
      if (a.re == null) a.re = '';
      if (a.ts == null) a.ts = '';
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

    Points.prototype.initialize = function(models, options) {
      if (models == null) models = [];
      if (options == null) options = {};
      if (_.isEmpty(models)) models = this.precious(options.data);
      return this.reset(models);
    };

    Points.prototype.precious = function(json) {
      var group, i, id, idx, it, item, its, key, keys, objs, sid, val, _ref;
      if (json == null) return [];
      _ref = [[], 0], objs = _ref[0], idx = _ref[1];
      for (i in json) {
        group = json[i];
        switch (i) {
          case '1':
          case '2':
            keys = {
              0: "lon",
              1: "lat",
              2: "dau",
              3: "day_lon",
              4: "day_lat",
              5: "day_dau"
            };
            for (id in group) {
              it = group[id];
              sid = i === "2" ? "" + (10000 + new Number(id)) : id;
              item = ensemble.sid(sid);
              its = item.get('id');
              objs.push({
                id: its === '?' ? sid : its,
                sid: sid
              });
              for (key in it) {
                val = it[key];
                objs[idx][keys[key]] = val;
              }
              idx++;
            }
        }
      }
      return objs;
    };

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

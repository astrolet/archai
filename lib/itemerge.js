(function() {
  var Backbone, Itemerge, traits, _,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  _ = require('underscore');

  Backbone = require('backbone-rel');

  Itemerge = (function(_super) {

    __extends(Itemerge, _super);

    function Itemerge() {
      Itemerge.__super__.constructor.apply(this, arguments);
    }

    Itemerge.prototype.initialize = function(attributes) {
      var trait, _i, _len, _ref, _ref2, _ref3;
      if (attributes == null) attributes = {};
      _ref2 = (_ref = attributes.traits) != null ? _ref : [];
      for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
        trait = _ref2[_i];
        _.extend(this, traits[trait]);
      }
      if (this.planet == null) this.planet = false;
      return (_ref3 = this.dispositor) != null ? _ref3 : this.dispositor = false;
    };

    return Itemerge;

  })(Backbone.RelationalModel);

  traits = {
    planet: {
      planet: true
    },
    dispositor: {
      dispositor: true
    }
  };

  module.exports = Itemerge;

}).call(this);

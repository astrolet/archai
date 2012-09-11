(function() {
  var Backbone, Ensemble, Itemerge, care, more, polyglot, _,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  _ = require('underscore');

  Backbone = require('backbone');

  Itemerge = require('./itemerge');

  polyglot = require('upon').polyglot;

  care = require('there').care;

  more = require('there').more;

  Ensemble = (function(_super) {

    __extends(Ensemble, _super);

    function Ensemble() {
      Ensemble.__super__.constructor.apply(this, arguments);
    }

    Ensemble.prototype.model = Itemerge;

    Ensemble.prototype.inits = {
      planets: {
        the: [["Η", 25, 108, "MO", 1, "☽", "Asklēpios", "Selēnē"], ["Ε", 20, 76, "ME", 2, "☿", "Hermēs", "Hermēs"], ["Ι", 8, 82, "VE", 3, "♀", "Anubio", "Aphrodite"], ["Ω", 19, 120, "SO", 0, "☉", "Nechepsō & Petosiris", "Hēlios"], ["Α", 15, 66, "MA", 4, "♂", "Abramos", "Arēs"], ["Υ", 12, 79, "JU", 5, "♃", "Orpheus", "Zeus"], ["Ο", 30, 57, "SA", 6, "♄", "Kritodēmos", "Kronos"]],
        add: {
          traits: ["traditional", "planet", "dispositor", "index"]
        },
        attributes: {
          key: "id",
          use: {
            "id": 3,
            "sid": 4,
            "u": 5,
            "name": null,
            "minor": 1,
            "major": 2
          },
          related: {
            "vowel": 0,
            "founder": 6,
            "phonetic": 7
          }
        }
      },
      dispositors: {
        the: [["NN", "☊", 11], ["SN", "☋", null]],
        add: {
          traits: ["dispositor"]
        },
        attributes: {
          key: "id",
          use: {
            id: 0,
            u: 1,
            name: null,
            sid: 2
          }
        }
      },
      angles: {
        the: [["AS", "⇠"], ["MC", "⇡"], ["DS", "⇢"], ["IC", "⇣"]],
        add: {
          traits: ["angle"]
        },
        attributes: {
          key: "id",
          use: {
            id: 0,
            u: 1,
            name: null
          }
        }
      },
      outers: {
        the: [["UR", "♅", 7], ["NE", "♆", 8], ["PL", "♇", 9]],
        add: {
          traits: ["modern", "outer", "planet", "index"]
        },
        attributes: {
          key: "id",
          use: {
            id: 0,
            sid: 2,
            u: 1,
            name: null
          }
        }
      },
      further: {
        the: [[15, "Chiron", "\u26B7"], [17, "Ceres", "\u26B3"], [18, "Pallas", "\u26B4"], [19, "Juno", "\u26B5"], [20, "Vesta", "\u26B6"]],
        add: {
          traits: ["modern", "index"]
        },
        attributes: {
          key: "id",
          use: {
            id: 1,
            sid: 0,
            name: null
          }
        }
      },
      utility: {
        the: [["-", "Use through `@getNone`."], ["!", "Use through `@getError`."], ["?", "Use through `@getUnknown`."]],
        add: {
          traits: []
        },
        attributes: {
          key: "id",
          use: {
            id: 0,
            note: 1,
            name: null
          }
        }
      }
    };

    Ensemble.prototype.words = {
      expect: ["name"],
      filler: ["id"],
      data: {
        "-": {
          name: {
            en: [true, "None"],
            bg: [true, "Няма"]
          }
        },
        "!": {
          name: {
            en: [true, "Error"],
            bg: [true, "Грешка"]
          }
        },
        "?": {
          name: {
            en: [true, "Unknown"],
            bg: [true, "Незнайно"]
          }
        }
      }
    };

    Ensemble.prototype.initialize = function(models, cosmos) {
      var add, attributes, e, init, item, key, value, _i, _j, _len, _len2, _ref, _ref2, _ref3, _ref4, _ref5, _ref6;
      this.cosmos = cosmos;
      if (this.cosmos != null) {
        this.school = (_ref = this.cosmos.school) != null ? _ref : null;
        this.language = (_ref2 = this.cosmos.language) != null ? _ref2 : null;
      }
      _.extend(this.words.data, care);
      for (key in more) {
        add = more[key];
        if (this.inits[key] != null) {
          this.inits[key].the = _.union(this.inits[key].the, add);
        }
      }
      _.extend(this, polyglot.ensure);
      if (!this.translatable(_.values(this.inits))) {
        throw "Itemerge stuff can't be named!";
      }
      e = [];
      _ref3 = _.values(this.inits);
      for (_i = 0, _len = _ref3.length; _i < _len; _i++) {
        init = _ref3[_i];
        _ref4 = init.the;
        for (_j = 0, _len2 = _ref4.length; _j < _len2; _j++) {
          item = _ref4[_j];
          attributes = {};
          _ref5 = init.attributes.use;
          for (key in _ref5) {
            value = _ref5[key];
            attributes[key] = item[value];
          }
          _ref6 = init.add;
          for (key in _ref6) {
            value = _ref6[key];
            attributes[key] = value;
          }
          e.push(attributes);
        }
      }
      this.reset(e);
      return this;
    };

    Ensemble.prototype.id = function(id) {
      var _ref;
      return (_ref = this.get(id)) != null ? _ref : this.getUnknown();
    };

    Ensemble.prototype.sid = function(id) {
      var found;
      found = this.find(function(item) {
        return ("" + (item.get('sid'))) === ("" + id);
      });
      return found != null ? found : this.getUnknown();
    };

    Ensemble.prototype.planets = function() {
      return new Backbone.Collection(this.filter(function(item) {
        return _.include(item.attributes.traits, 'planet');
      }));
    };

    Ensemble.prototype.seven = function() {
      return new Backbone.Collection(this.filter(function(item) {
        return _.include(item.attributes.traits, 'traditional');
      }));
    };

    Ensemble.prototype.dispositors = function() {
      return new Backbone.Collection(this.filter(function(item) {
        return _.include(item.attributes.traits, 'dispositor');
      }));
    };

    Ensemble.prototype.index = function() {
      return new Backbone.Collection(this.filter(function(item) {
        return _.include(item.attributes.traits, 'index');
      }));
    };

    Ensemble.prototype.getNone = function() {
      return this.get("-");
    };

    Ensemble.prototype.getError = function() {
      return this.get("!");
    };

    Ensemble.prototype.getUnknown = function() {
      return this.get("?");
    };

    return Ensemble;

  })(Backbone.Collection);

  module.exports = Ensemble;

}).call(this);

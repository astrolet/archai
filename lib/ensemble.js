(function() {
  var Backbone, Ensemble, Itemerge, polyglot, _,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  _ = require('underscore');

  Backbone = require('backbone');

  Itemerge = require('./itemerge');

  polyglot = require('./polyglot');

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
          traits: ["traditional", "planet", "dispositor"]
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
          traits: ["modern", "outer", "planet"]
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
      beyond: {
        the: [[15, "Chiron", "\u26B7"], [17, "Ceres", "\u26B3"], [18, "Pallas", "\u26B4"], [19, "Juno", "\u26B5"], [20, "Vesta", "\u26B6"], [10128, "Nemesis", ""], [17066, "Nessus", ""], [30000, "Varuna", ""], [60000, "Quaoar", ""], [100377, "Sedna", ""], [146108, "Haumea", ""], [146199, "Eris", ""], [146472, "Makemake", ""]],
        add: {
          traits: ["modern", "outer"]
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
        "MO": {
          name: {
            en: ["Selene", "Moon"],
            el: [true, "Σελήνη"],
            bg: ["Селена", "Луна"]
          }
        },
        "ME": {
          name: {
            en: ["Hermes", "Mercury"],
            el: [true, "Ἑρμῆς"],
            bg: ["Хермес", "Меркурий"]
          }
        },
        "VE": {
          name: {
            en: ["Aphrodite", "Venus"],
            el: [true, "Ἀφροδίτη"],
            bg: ["Афродита", "Венера"]
          }
        },
        "SO": {
          name: {
            en: ["Helios", "Sun"],
            el: [true, "Ἥλιος"],
            bg: ["Хелиос", "Слънце"]
          }
        },
        "MA": {
          name: {
            en: ["Ares", "Mars"],
            el: [true, "Ἄρης"],
            bg: ["Арес", "Марс"]
          }
        },
        "JU": {
          name: {
            en: ["Zeus", "Jupiter"],
            el: [true, "Ζεύς"],
            bg: ["Зевс", "Юпитер"]
          }
        },
        "SA": {
          name: {
            en: ["Kronos", "Saturn"],
            el: [true, "Κρόνος"],
            bg: ["Кронос", "Сатурн"]
          }
        },
        "NN": {
          name: {
            en: [true, "North Node"]
          }
        },
        "SN": {
          name: {
            en: [true, "South Node"]
          }
        },
        "AS": {
          name: {
            en: [false, "Ascendant"]
          }
        },
        "MC": {
          name: {
            en: [false, "Midheaven"]
          }
        },
        "DS": {
          name: {
            en: [false, "Descendant"]
          }
        },
        "IC": {
          name: {
            en: [false, "Imum Coeli"]
          }
        },
        "UR": {
          name: {
            en: [false, "Uranus"]
          }
        },
        "NE": {
          name: {
            en: [false, "Neptune"]
          }
        },
        "PL": {
          name: {
            en: [false, "Pluto"]
          }
        },
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
      var attributes, e, init, item, key, value, _i, _j, _len, _len2, _ref, _ref2, _ref3, _ref4;
      this.cosmos = cosmos;
      if (this.cosmos != null) {
        this.school = this.cosmos.school;
        this.language = this.cosmos.language;
      }
      _.extend(this, polyglot.ensure);
      if (!this.translatable(_.values(this.inits))) {
        throw "Itemerge stuff can't be named!";
      }
      e = [];
      _ref = _.values(this.inits);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        init = _ref[_i];
        _ref2 = init.the;
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          item = _ref2[_j];
          attributes = {};
          _ref3 = init.attributes.use;
          for (key in _ref3) {
            value = _ref3[key];
            attributes[key] = item[value];
          }
          _ref4 = init.add;
          for (key in _ref4) {
            value = _ref4[key];
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

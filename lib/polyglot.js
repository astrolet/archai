(function() {
  var _;

  _ = require("underscore");

  module.exports = {
    ensure: {
      translatable: function(inits) {
        var attribute, attributes, i, init, word, _i, _j, _len, _len2, _ref, _ref2;
        if ((this.words != null) && !_.isEmpty(inits)) {
          if (this.school == null) this.school = "h";
          if (this.language == null) this.language = "en";
          _.extend(this, module.exports.methods);
          for (_i = 0, _len = inits.length; _i < _len; _i++) {
            init = inits[_i];
            for (i = 0, _ref = this.words.expect.length - 1; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
              init.attributes.use[this.words.expect[i]] = init.the[0].length + i;
            }
            i = 0;
            _ref2 = _.values(this.translation(this.language, this.school, _.pluck(init.the, init.attributes.use[init.attributes.key])));
            for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
              attributes = _ref2[_j];
              for (attribute in attributes) {
                word = attributes[attribute];
                if (attribute === "key_id") continue;
                init.the[i].push(word);
              }
              i++;
            }
          }
          return true;
        } else {
          return false;
        }
      }
    },
    methods: {
      translation: function(language, school, keys, select) {
        var i, key, out, position, stuff, value, word, _i, _j, _len, _len2, _ref;
        if (keys == null) keys = [];
        if (select == null) select = this.words.expect;
        switch (this.school) {
          case "h":
            position = 0;
            break;
          case "m":
            position = 1;
            break;
          default:
            throw "Unknown '" + this.school + "' position.";
        }
        if (_.isEmpty(keys)) {
          keys = _.keys(this.words.data);
        } else {
          keys = _.intersection(keys, _.keys(this.words.data));
        }
        out = [];
        i = -1;
        for (_i = 0, _len = keys.length; _i < _len; _i++) {
          key = keys[_i];
          out[++i] = {
            "key_id": key
          };
          for (_j = 0, _len2 = select.length; _j < _len2; _j++) {
            word = select[_j];
            stuff = (_ref = this.words.data[key][word][this.language]) != null ? _ref : this.words.data[key][word]['en'];
            if (position === 0) {
              value = stuff[position];
              if (_.isString(value)) {
                out[i][word] = value;
              } else {
                switch (value) {
                  case true || null:
                    out[i][word] = stuff[1];
                    break;
                  case false:
                    out[i][word] = this.words.data[key][word]['en'][position];
                    if (!_.isString(out[i][word])) {
                      out[i][word] = this.words.data[key][word]['en'][1];
                    }
                }
              }
            } else {
              out[i][word] = stuff[position];
            }
          }
        }
        return out;
      },
      translate: function(language, school, select) {
        var attributes, key, _i, _len, _ref;
        if (language == null) language = this.language;
        if (school == null) school = this.school;
        if (this.language !== language || this.school !== school) {
          this.school = school;
          this.language = language;
          _ref = this.translation(this.language, this.school, this.pluck('id'), select);
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            attributes = _ref[_i];
            key = attributes.key_id;
            delete attributes.key_id;
            this[this.words.model || 'get'](key).set(attributes);
          }
        }
        return this;
      }
    }
  };

}).call(this);

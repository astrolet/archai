(function() {
  var Ensemble, ensemble;

  Ensemble = require('./ensemble');

  ensemble = new Ensemble;

  module.exports = function() {
    ensemble.comparator = function(stuff) {
      return stuff.get('name');
    };
    return ensemble.translate('en', 'm').sort().index().map(function(item) {
      var sid, _ref;
      sid = item['attributes']['sid'];
      sid = sid >= 10000 ? sid - 10000 : sid;
      return {
        name: item['attributes']['name'],
        sid: sid,
        wid: (_ref = item['attributes']['wid']) != null ? _ref : ''
      };
    });
  };

}).call(this);

// Exports
[ 'Points'
, 'Ensemble'
, 'theres'
, 'Zodiac'
, 'Cosmos'
].forEach(function(name) {
  var path = './lib/' + name.toLowerCase();
  exports[name] = require(path);
});


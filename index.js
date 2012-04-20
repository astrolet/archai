// Exports
[ 'Points'
, 'Itemerge'
, 'Ensemble'
, 'polyglot'
, 'Gaia'
].forEach(function(name) {
  var path = './lib/' + name.toLowerCase();
  exports[name] = require(path);
});


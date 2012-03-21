// Exports
[ 'degrees'
, 'coordinates'
, 'Itemerge'
, 'Ensemble'
, 'polyglot'
, 'ut'
, 'Gaia'
].forEach(function(name) {
  var path = './lib/' + name.toLowerCase();
  exports[name] = require(path);
});


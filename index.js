require.paths.unshift(__dirname + "/lib");
require.paths.unshift(__dirname + "/node_modules");

// Exports
['gaia', 'massage', 'undermix'].forEach(function(path) {
  var module = require(path);
  for (var i in module) {
    exports[i] = module[i];
  }
});

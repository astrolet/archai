Ensemble = require './ensemble'
ensemble = new Ensemble

# In the future, this could be a Backbone Collection too.
# Keep it simple for now - hardcoded to (and sorted by) modern English names.
# Just something to easily display.

module.exports = ->
  ensemble.comparator = (stuff) -> stuff.get('name')
  ensemble.translate('en', 'm').sort().index().map (item) ->
    sid = item['attributes']['sid']
    sid = if sid >= 10000 then sid - 10000 else sid
    name: item['attributes']['name'], sid: sid


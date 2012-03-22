_       = require 'underscore'
degrees = require './degrees'


class Coordinates

  # Ecliptical CelestialCoordinates (factory method).
  of: (x, y = 0) ->
    # Perhaps at a later time,
    # other coordinate systems can be loaded through x.
    # For example equatorial x.rasc / x.decl pair.
    [x, y] = [x.lon, x.lat] if x?.lon? and x?.lat?
    new CelestialCoordinates x, y

  # GeoCoordinates
  geo: (x, y) ->
    throw "To become geo coordinates (Gaia replacement), later on..."


# Perhaps this should extend `Backbone.Model`, so that the lon & lat attributes
# can be watched for changes and derivative coordinates recalculated?
class CelestialCoordinates

  # Based on the ecliptic, however there will be code for doing conversions to
  # also support the equatorial [right-ascention, declination], at least...
  constructor: (lon, lat) ->
    @lon = degrees.of lon, 'longitude'
    @lat = degrees.of lat

  # A shortcut for getting both longitude and latitude with one call.<br/>
  # TODO: pass the `rest` as function parameters.  Contribute to Backbone,
  # or impelement my own `result` - it's easier with CoffeeScript...
  ecliptical: (r, rest...) ->
    if r? then [_.result(@lon, r), _.result(@lat, r)] else [@lon, @lat]


module.exports = new Coordinates


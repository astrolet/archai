_           = require 'underscore'
Backbone    = require 'backbone'
coordinates = require './coordinates'


class Point extends Backbone.Model

  initialize: (attributes) ->
    attributes.lon ?= 0 # Note: this should perhaps be the default for degrees
    @at = coordinates.of attributes.lon, attributes.lat
    attributes.lat = @at.lat.dec unless attributes.lat? # latitude default of 0
    attributes.timeshift ?= null
    attributes.reason    ?= null
    @set attributes


class Points extends Backbone.Collection

  model: Point

  # The first point or the @getNone id of Ensemble.
  a: -> @at(0) ? new Point id: '-'


module.exports = Points


_           = require 'underscore'
Backbone    = require 'backbone'
coordinates = require './coordinates'


class Point extends Backbone.Model

  # Note: 0 should perhaps be the default for degrees?
  atCoordinates: (lon = 0, lat) ->
    @at = coordinates.of @get("lon") ? lon, @get("lat") ? lat
    @at.ecliptical 'dec'

  initialize: (a) ->
    [a.lon, a.lat] = @atCoordinates a.lon, a.lat
    a.timeshift ?= null
    a.reason    ?= null
    @set a

    # TODO: with a newer Backbone,
    # `@on "change:lon change:lat", @atCoordinates` instead.
    @bind "change:lon", @atCoordinates
    @bind "change:lat", @atCoordinates


class Points extends Backbone.Collection

  model: Point

  # The first point or the @getNone id of Ensemble.
  a: -> @at(0) ? new Point id: '-'


module.exports = Points


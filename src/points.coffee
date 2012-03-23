_             = require 'underscore'
Backbone      = require 'backbone'
coordinates   = require './coordinates'
ensemble = new (require './ensemble')


class Point extends Backbone.Model

  # Note: 0 should perhaps be the default for degrees?
  atCoordinates: (lon = 0, lat) ->
    @at = coordinates.of @get("lon") ? lon, @get("lat") ? lat
    @at.ecliptical 'dec'

  initialize: (a) ->
    [a.lon, a.lat] = @atCoordinates a.lon, a.lat
    a.re ?= '' # regarding reason
    a.ts ?= '' # timeshift - more, related moments
    @set a

    # TODO: with a newer Backbone,
    # `@on "change:lon change:lat", @atCoordinates` instead.
    @bind "change:lon", @atCoordinates
    @bind "change:lat", @atCoordinates


class Points extends Backbone.Collection

  model: Point

  initialize: (models = [], options = {}) ->
    models = @precious options if _.isEmpty models
    @reset models

  precious: (options) ->
    [json, settings] = [options.data, options.settings]
    return [] unless json?
    [objs, idx] = [[], 0]
    for i, group of json
      switch i
        when '1', '2'
          keys =
            0: "lon"
            1: "lat"
            2: "dau"
            3: "day_lon"
            4: "day_lat"
            5: "day_dau"
          for id, it of group
            sid = if i is "2" then "#{10000 + new Number(id)}" else id
            item = ensemble.sid sid
            its = item.get('id')
            objs.push
              id: if its is '?' then sid else its
              sid: sid
            for key, val of it
              objs[idx][keys[key]] = val
            idx++
        when '3'
          # Adding the frontal so many.
          keys = ["AS", "MC", "ARMC", "VX", "EQAS"]
          for num, val of group
            if keys[num]?
              objs.push
                id: "#{[keys[num]]}"
                sid: null
                lon: val
                day_lon: null
              idx++
        when '4'
          keys = []
          keys.push "H#{count}" for count in [1..12]
          for num, val of group
            objs.push
              id: "#{[keys[num]]}"
              sid: null
              lon: val
              day_lon: null
              re: settings.houses if settings?.houses? # TODO: full system name
            idx++
    objs

  # The first point or the @getNone id of Ensemble.
  a: -> @at(0) ? new Point id: '-'


module.exports = Points


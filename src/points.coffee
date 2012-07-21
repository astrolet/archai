_             = require 'underscore'
Backbone      = require 'backbone'
coordinates   = require('upon').coordinates
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
    json = options.data
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
          # TODO: check if all of these are on the ecliptic (i.e. lon values)
          # Also see if all of them are to be used and if in order - whitelist?
          # For example we may just want the Vertex from the following:
          # `"ARMC", "VX", "EQAS"`.  Furthermore, we may want some angles
          # for calculations / inference, but not to show - in which case
          # it would be Eden's (i.e. `eden -o phase`) whitelist.
          keys = ["AS", "MC"]
          for num, val of group
            if keys[num]?
              objs.push
                id: "#{[keys[num]]}"
                sid: null
                lon: val
                day_lon: null
              idx++
        when '4'
          for count in [1..12]
            # Whole-sign houses start with 'T' for topics, all others with 'H'.
            objs.push
              id: "#{if group[12] is 'W' then 'T' else 'H'}#{count}"
              sid: null
              lon: group[count-1]
              day_lon: null
              re: @houses[group[12]]
            idx++
    objs

  # Minimal lowercase tags, a reason.
  houses: { "P": "placidus"
          , "K": "koch"
          , "O": "porphyrius"
          , "R": "regiomontanus"
          , "C": "campanus"
          , "A": "ascendant"
          , "E": "equal"
          , "V": "vehlow-equal"
          , "W": "whole-sign"
          , "X": "axial-rotation"
          , "H": "horizontal"
          , "T": "topocentric"
          , "B": "alcabitus"
          , "M": "morinus"
          , "U": "krusinski-pisa"
          , "G": "gauquelin-sectors"
          }

  # The first point or the @getNone id of Ensemble.
  a: -> @at(0) ? new Point id: '-'


module.exports = Points


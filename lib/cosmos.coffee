Backbone = require 'backbone-rel'
Ensemble = require './ensemble'
Zodiac   = require './zodiac'


# Celestial sphere stuff
# unsure if the @level (regular vs 12th part) is in the representation or point
# ... probably point.rep vs point._12 is enough for addressing @level
class Point extends Backbone.RelationalModel

  initialize: ->


# Builder class of the Cosmos, once created by the Demiurge
class Cosmos

  # The dispositors from PI to AQ as Zodiac initializes its representations.
  # Expected to vary at a later time, therefore the data is passed in from here.
  # The domicile and exaltation dispositors can be fully listed, while the
  # trigon lords, decanic faces and monomoria can be significantly shortened
  # if generated through various algorithms.
  dispositors:
    domicile:
      [ "JU", "MA", "VE"
      , "ME", "MO", "SO"
      , "ME", "VE", "MA"
      , "JU", "SA", "SA"
      ]
    exaltation:
      [ ["VE", 27], ["SO", 19], ["MO",  3]
      , ["NN",  3], ["JU", 15], [ null ]
      , ["ME", 15], ["SA", 21], [ null ]
      , ["SN",  3], ["MA", 28], [ null ]
      ]
    trigons:
      F: { C: "SA", D: "SO", N: "JU" }
      E: { C: "MA", D: "VE", N: "MO" }
      A: { C: "JU", D: "SA", N: "ME" }
      W: { C: "MO", D: "VE", N: "MA" }
    confines:
      EC:
        [ { VE: 12, JU:  4, ME: 3, MA: 9, SA: 2 }
        , { JU:  6, VE:  6, ME: 8, MA: 5, SA: 5 }
        , { VE:  8, ME:  6, JU: 8, SA: 5, MA: 3 }
        , { ME:  6, JU:  6, VE: 5, MA: 7, SA: 6 }
        , { MA:  7, VE:  6, ME: 6, JU: 7, SA: 4 }
        , { JU:  6, VE:  5, SA: 7, ME: 6, MA: 6 }
        , { ME:  7, VE: 10, JU: 4, MA: 7, SA: 2 }
        , { SA:  6, ME:  8, JU: 7, VE: 7, MA: 2 }
        , { MA:  7, VE:  4, ME: 8, JU: 5, SA: 6 }
        , { JU: 12, VE:  5, ME: 4, SA: 5, MA: 4 }
        , { ME:  7, JU:  7, VE: 8, SA: 4, MA: 4 }
        , { ME:  7, VE:  6, JU: 7, MA: 5, SA: 5 }
        ]
      PC:
        [ { VE:  8, JU:  6, ME: 6, MA: 6, SA: 4 }
        , { JU:  6, VE:  8, ME: 7, MA: 5, SA: 4 }
        , { VE:  8, ME:  7, JU: 7, SA: 4, MA: 4 }
        , { ME:  7, JU:  6, VE: 7, MA: 6, SA: 4 }
        , { MA:  6, JU:  7, ME: 7, VE: 7, SA: 3 }
        , { SA:  6, ME:  7, VE: 6, JU: 6, MA: 5 }
        , { ME:  7, VE:  6, JU: 5, SA: 6, MA: 6 }
        , { SA:  6, VE:  5, JU: 8, ME: 5, MA: 6 }
        , { MA:  6, JU:  8, VE: 7, ME: 6, SA: 3 }
        , { JU:  8, VE:  6, ME: 5, SA: 6, MA: 5 }
        , { VE:  6, ME:  6, JU: 7, MA: 6, SA: 5 }
        , { SA:  6, ME:  6, VE: 8, JU: 5, MA: 5 }
        ]
    # TODO add:
    faces: null
    monomoria: null
  # What representation, face, portion each planet is dispositing
  # is added-up here in case we need it for reverse lookup.
  # TODO initialize with: _.union _.pluck(Ensemble.planets.the, 3), # ...
  # _.pluck(Ensemble.dispositors.the, x)
  dispositing: {}

  # Helpers for initializing the attributes of `@zodiac`, `@ensemble`, etc.
  determine:
    element: (idz) ->
      switch idz % 4
        when 0 then "W" # Water-like
        when 1 then "F" #  Fire-like
        when 2 then "E" # Earth-like
        when 3 then "A" #   Air-like
        else throw "Cannot determine element for representation number #{idz}."

  # TODO: do all attributes generation with the same function, as for example
  # Zodiac and Ensemble dispositors logic gets mixed-up for doing reverse too?
  # So far, having a separate dispositors module doesn't seem too justified...
  zodiacAttributes: ->
    zodiac = []
    # Collection data format for trigons is needed, hence `trigon_lords`,
    # ready for nesting into representations.
    trigon_lords = {}
    for element, lords of @dispositors.trigons
      trigon_lords[element] = []
      for key, value of lords
        trigon_lords[element].push id: key, lord: value

    for i in [0..11]
      idz = if i is 0 then 12 else i
      zodiac.push {}
      # Reusable, attribute-generating helper calls.
      zodiac[i].element = @determine.element idz
      # Inline (for now) logic to generate disposited `@zodiac` attributes
      # as well as `@dispositing` attributes for `@ensemble`.
      for dispositor, data of @dispositors
        switch dispositor
          when "domicile"
            value = data[i]
            reverse = idz
          when "exaltation"
            value = data[i][0]
            reverse = idz
          when "trigons"
            value = trigon_lords[@determine.element idz]
            reverse = null # what to do with it?
          when "confines"
            value = []
            for key, values of data
              n = 1; last = 0
              for lord, portions of values[i]
                idc = "#{key}-#{n++}"
                from = last + 1
                till = last + portions
                last = till
                value.push
                  id: idc
                  scheme: key
                  portions: portions
                  lord: lord
                  from: from
                  till: till
            reverse = null # kind of similar unknown...
          else continue
        zodiac[i][dispositor] = value
        # The following @dispositing is yet to be finalized...
        if value isnt null and reverse isnt null
          @dispositing[value] ?= {} # initialize(d) from elsewhere?
          @dispositing[value][dispositor] = reverse

    zodiac


  # Note: the preferences would eventually come from a real
  # School + User (more models / collections to do).
  # Also, for some reason polyglot doesn't like doublely-`undefined` language,
  # which is not a problem, because Cosmos will know its preferences.
  constructor: (@language = "en", @school) ->
    @zodiac = new Zodiac @zodiacAttributes(), @
    # TODO: pass @dispositing instead of [] to the new Ensemble.
    # The `id`s are probably also needed, because `@ensemble` will contain
    # more than just dispositors...
    @ensemble = new Ensemble [], @


  # (re?)-does Demiurge's work
  recreate: ->

  # makes a point that points to an item from the ensemble
  point: (ephemeris_id) ->


module.exports = Cosmos


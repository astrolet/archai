_ = require 'underscore'
Backbone = require 'backbone'
Itemerge = require './itemerge'
polyglot = require './polyglot'


# Mix of planets / dispositors (according to school) + other points of interest.
# Anything that can be pointed to (by a point) is in this collection.
class Ensemble extends Backbone.Collection

  model: Itemerge

  inits:

    # The planets are in Chaldean order (of Nechepso) with the following attributes:
    #
    # 1. Greek Vowel
    # 2. Minor Period
    # 3. Major Period
    # 4. International Abbreviation ID
    # 5. Swiss Ephemeris ID
    # 6. Legendary Founder Name(s)
    # 7. Greek Phonetic Name
    # 8. Name (added based on language and school preference)
    planets:
      the: [ [ "Η", 25, 108, "MO", 1, "Asklēpios", "Selēnē" ]
           , [ "Ε", 20,  76, "ME", 2, "Hermēs", "Hermēs" ]
           , [ "Ι",  8,  82, "VE", 3, "Anubio", "Aphrodite" ]
           , [ "Ω", 19, 120, "SO", 0, "Nechepsō & Petosiris", "Hēlios" ]
           , [ "Α", 15,  66, "MA", 4, "Abramos", "Arēs" ]
           , [ "Υ", 12,  79, "JU", 5, "Orpheus", "Zeus" ]
           , [ "Ο", 30,  57, "SA", 6, "Kritodēmos", "Kronos" ]
           ]
      add:
        traits: [ "planet", "dispositor" ]
      # The `planets.attributes.use`-ed by array index position -
      # do become instance data.
      attributes:
        key: "id"
        use:
          "id": 3
          "sid": 4
          "name": null # the last (not there yet), added / set upon instantiation
          "minor": 1
          "major": 2
        # Related is for later - relations, etc.
        related:
          "vowel": 0
          "founder": 5
          "phonetic": 6

    # Dispositors that aren't planets.
    dispositors:
      the: [ [ "NN", 11 ]
           , [ "SN", null ]
           ]
      add:
        traits: [ "dispositor" ]
      attributes:
        key: "id"
        use:
          id: 0
          sid: 1
          name: null

    # System utility objects.  The spectrum of their meaning is TBD.
    utility:
      the: [ [ "-", "Use through `@getNone`."]
           , [ "!", "Use through `@getError`."]
           , [ "?", "Use through `@getUnknown`."]
           ]
      add:
        traits: []
      attributes:
        key: "id"
        use:
          id: 0
          note: 1
          name: null

  # See _./polyglot.coffee_ for assumptions.
  # Try ising different attributes.key for the various itemerge types.
  # This will come in handy for minor ojects and means a more uniform id (any)
  # can be selected instead of mixing ids, even if wthout the risk of overlap,
  # by which I mean accidentally colliding ids - unlikely, anyway.
  words:
    expect: [ "name" ]
    data:

      "MO":
        name:
          en: [ "Selene",         "Moon" ]
          el: [ true,             "Σελήνη" ]
          bg: [ "Селена",         "Луна" ]
      "ME":
        name:
          en: [ "Hermes",         "Mercury" ]
          el: [ true,             "Ἑρμῆς" ]
          bg: [ "Хермес",         "Меркурий" ]
      "VE":
        name:
          en: [ "Aphrodite",      "Venus" ]
          el: [ true,             "Ἀφροδίτη" ]
          bg: [ "Афродита",       "Венера" ]
      "SO":
        name:
          en: [ "Helios",         "Sun" ]
          el: [ true,             "Ἥλιος" ]
          bg: [ "Хелиос",         "Слънце" ]
      "MA":
        name:
          en: [ "Ares",           "Mars" ]
          el: [ true,             "Ἄρης" ]
          bg: [ "Арес",           "Марс" ]
      "JU":
        name:
          en: [ "Zeus",           "Jupiter" ]
          el: [ true,             "Ζεύς" ]
          bg: [ "Зевс",           "Юпитер" ]
      "SA":
        name:
          en: [ "Kronos",         "Saturn" ]
          el: [ true,             "Κρόνος" ]
          bg: [ "Кронос",         "Сатурн" ]

      "NN":
        name:
          en: [ true,             "North Node" ]
      "SN":
        name:
          en: [ true,             "South Node" ]

      "-":
        name:
          en: [ true,             "None" ]
          bg: [ true,             "Няма" ]
      "!":
        name:
          en: [ true,             "Error" ]
          bg: [ true,             "Грешка" ]
      "?":
        name:
          en: [ true,             "Unknown" ]
          bg: [ true,             "Незнайно" ]


  # Sometimes (only when testing?) Ensemble is instantiated without `@cosmos`.
  # The @language & @school are optional - defaults set by `@translatable ()`.
  initialize: (models, @cosmos) ->
    if @cosmos?
      @school   = @cosmos.school
      @language = @cosmos.language

    # Add `@words` translation.
    _.extend @, polyglot.ensure
    unless @translatable _.values @inits
      throw "Itemerge stuff can't be named!"

    # Assemble the ensemble attributes for self-resetting with.
    e = []
    for init in _.values @inits
      for item in init.the
        attributes = {}
        for key, value of init.attributes.use
          attributes[key] = item[value]
        # All init.add is appended to the attributes
        # for `QueryCollection` filters and possibly other use
        # where the attributes are the same per init category.
        for key, value of init.add
          attributes[key] = value

        e.push attributes
    @reset e

    @ # chainable


  # TODO: this probably shouldn't return a new (copy), but a filtered collection
  # isn't a real collection with Underscore mixed in.  Would like to use
  # Backbone.Query, but it isn't a node module yet...
  planets: ->
    new Backbone.Collection @filter (item) ->
      _.include item.attributes.traits, 'planet'

  # Needs improvement, just like `@planets` does.
  # TODO: furthermore, these functions can be added to `@` automatically...
  # All that's needed is make sure the `@inits` keys match what the methods
  # should be called.
  dispositors: ->
    new Backbone.Collection @filter (item) ->
      _.include item.attributes.traits, 'dispositor'

  # The following get system objects whose `id`s are possibly subject to change.
  # The `@getNone` is needed for representations that have no exaltation
  # dispositor.  There may later be needed a different None as "Not Found" that
  # is different from being Unknown.  The meaning of all these will be
  # finalized as they become needed.  With the special getMethods (below),
  # The `id`s are completely arbitrary.
  # TODO: `getError`, at least, could take a string for logging, etc.

  getNone: ->
    @get "-"

  getError: ->
    @get "!"

  getUnknown: ->
    @get "?"


module.exports = Ensemble

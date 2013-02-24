_        = require 'underscore'
Backbone = require 'backbone-rel'
degrees  = require('upon').degrees
polyglot = require('there').polyglot
nestCollection = require './nest-collection'


# It would be better if we don't have to instantite all the 360 portions
# ... and setup dispositor relations for each!
class Portion extends Backbone.RelationalModel


# Not sure if dispositors.coffee would be reintroduced...  For now, the
# dispositors stuff scattered around.  Perhaps later it should be extracted
# and mixed-in according to Cosmos preferences.
# The various dispositor-fetching methods return a model from `Cosmos.ensemble`.
class TrigonLords extends Backbone.Collection

  initialize: (@attributes, o) ->
    @representation = o.representation

  dispositor: (id) ->
    @representation.collection.cosmos.ensemble.get id

  day: ->
    @dispositor (@get('D').get 'lord')

  night: ->
    @dispositor (@get('N').get 'lord')

  cooperating: ->
    @dispositor (@get('C').get 'lord')


class Confines extends Backbone.Collection

  initialize: (@attributes, o) ->
    @representation = o.representation
    # EC is for Egyptian Confines, there are at least also PC for Ptolemy's.
    @scheme = o.scheme ? (_.first @attributes).scheme # the first scheme
    @schemes = _.unique _.pluck @attributes, 'scheme' # array of all the schemes

  dispositor: (id) ->
    @representation.collection.cosmos.ensemble.get id

  # Get the confines dispositors of several (all possible) schemes.
  # Zodiac degrees array nicknamed `zodeg`.
  # TODO: change it back to degrees after the missing attributed bug is fixed.
  variants: (zodeg, schemes = @schemes) ->
    # TODO: this reprtesentation-relative further-more portion --
    # should probably be improved with mod('30').top() - which looks better...
    # mod is chainable degrees, instantiating new degrees
    # after taking the modulo.
    # TODO: furthermore, it is inappropriate to pass the representation number.
    # Just the relative degrees are needed.  The second parameter should come
    # from `@representation.get('idz')` - which attribute is currently missing!
    portion = degrees.lon(zodeg[1], zodeg[0]).rep('top')[1]
    dispositors = {}
    results = @filter (bounds) ->
      _.include(schemes, bounds.get 'scheme') and
      bounds.get('from') <= portion and
      bounds.get('till') >= portion
    for item in results
      dispositors[item.attributes.scheme] = @dispositor item.attributes.lord
    dispositors

  # Get the confines dispositor of just one (preferred) scheme.
  followed: (degrees, scheme = @scheme) ->
    (@variants degrees, [ scheme ])[scheme]


# Cosmic / canonical representation (is no longer called sign, nor image)
class Representation extends Backbone.RelationalModel

  # Dispositor getters - named as simple (i.e. short) as descriptively possible.

  domicile: ->
    @collection.cosmos.ensemble.get(@get "domicile")

  exaltation: ->
    # Signs without exaltation...  An `id` of `null` got with `getNone()`.
    # TODO: consider extending `Ensemble.get`.
    @collection.cosmos.ensemble.get(@get "exaltation") ? # or N/A (on next line)
    @collection.cosmos.ensemble.getNone()

  # TODO: each representation will have its 30 portions (nestedCollection)
  # which will point to a dispositor for monomoria and confines.
  # Decanic faces probably deserve their own (nested?) collection...
  initialize: (attributes) ->

    # The trigons attribute is tied to a `@trigons` nested collection.
    if attributes.trigons?
      @trigons = new TrigonLords (@get "trigons"), representation: @
      nestCollection @, 'trigons', @trigons

    # The confines attribute is tied to a `@confines` nested collection.
    if attributes.confines?
      @confines = new Confines (@get "confines"), representation: @
      nestCollection @, 'confines', @confines


# The 12 representations (instances and their relations)
class Zodiac extends Backbone.Collection

  model: Representation

  zoidia:
    the:
      [ [ 'PI' ] , [ 'AR' ] , [ 'TA' ]
      , [ 'GE' ] , [ 'CN' ] , [ 'LE' ]
      , [ 'VI' ] , [ 'LI' ] , [ 'SC' ]
      , [ 'SG' ] , [ 'CP' ] , [ 'AQ' ]
      ]
    attributes:
      key: "id"
      use:
        id: 0
        idz: 1 # through initialize
        name: null # polyglot's job

  words:
    expect: [ "name" ]
    filler: [ "id" ]
    data:
      "AR":
        name:
          en: [ "Ram", "Aries" ]
          el: [ true, "Κριός" ]
          bg: [ true, "Овен" ]
      "TA":
        name:
          en: [ "Bull", "Taurus" ]
          el: [ true, "Ταῦρος" ]
          bg: [ true, "Телец" ]
      "GE":
        name:
          en: [ "Twins", "Gemini" ]
          el: [ true, "Δίδυμοι" ]
          bg: [ true, "Близнаци" ]
      "CN":
        name:
          en: [ "Crab", "Cancer" ]
          el: [ true, "Καρκίνος" ]
          bg: [ true, "Рак" ]
      "LE":
        name:
          en: [ "Lion", "Leo" ]
          el: [ true, "Λέων" ]
          bg: [ true, "Лъв" ]
      "VI":
        name:
          en: [ "Virgin", "Virgo" ]
          el: [ true, "Παρθένος" ]
          bg: [ true, "Дева" ]
      "LI":
        name:
          en: [ "Balance", "Libra" ]
          el: [ true, "Ζυγός" ]
          bg: [ true, "Везни" ]
      "SC":
        name:
          en: [ "Scorpion", "Scoprio" ]
          el: [ true, "Σκορπίος" ]
          bg: [ true, "Скорпион" ]
      "SG":
        name:
          en: [ "Archer", "Sagittarius" ]
          el: [ true, "Τοξότης" ]
          bg: [ true, "Стрелец" ]
      "CP":
        name:
          en: [ "Goat-Horned", "Capricorn" ]
          el: [ true, "Ἀιγόκερως" ]
          bg: [ true, "Козирог" ]
      "AQ":
        name:
          en: [ "Water-Pourer", "Aquarius" ]
          el: [ true, "Φ̔δροχόος" ]
          bg: [ true, "Водолей" ]
      "PI":
        name:
          en: [ "Fishes", "Pisces" ]
          el: [ true, "Ἰχθύες" ]
          bg: [ true, "Риби" ]

  all: [1..12]


  # Sometimes (only when testing?) `Zodiac` is instantiated without `@cosmos`.
  # The @language & @school are optional - defaults set by `@translatable ()`.
  initialize: (models, @cosmos, attributes) ->
    if @cosmos?
      @school   = @cosmos.school
      @language = @cosmos.language

    for i in [0..11]
      @zoidia.the[i].push if i is 0 then 12 else i

    _.extend @, polyglot.ensure
    unless @translatable [ @zoidia ] then throw "The zoidia can't be named!"

    # Note: this could be extracted to a helper for reuse when resetting.
    # It only reorders the attributes.
    z = [] # zoidia
    for i in [0 .. @zoidia.the.length - 1]
      z.push {}
      for attribute, position of @zoidia.attributes.use
        z[i][attribute] = @zoidia.the[i][position]
      # Additional attributes are passed in by the Cosmos builder.
      _.extend z[i], attributes?[i]
    @reset z

    @ # chainable


  # Relies on the `@models` order not to change.  In this sense,
  # it's a kind of *hack*.
  id: (idz) ->
    @at if idz is 12 then 0 else idz


  # Question: wouldn't it be better to implement @ids ...
  # and based on a filtered subset of the collection, pluck the 'name' of each?
  names: (which = @all) ->
    which = [which] unless _.isArray which

    names = []
    for idz in which
      names.push @id(idz).get 'name'
    names


  # Take some or @all idz numbers + iterator function to filter them with.
  # This is mostly for DRY @male & @female (odd / even) checks.
  # Note if male & female become initialized to "gender" attribute,
  # we could perhaps skip adding (the redundant) idz to `@zoidia.attributes.use`
  # and instead `_.pluck @zoidia.the, "idz"`.
  idzF: (idz = @all, iterator) ->
    idz = [idz] unless _.isArray idz

    # Kind-of sorts the collection by idz.
    _.intersection idz, _.filter (@pluck 'idz'), iterator

  female: (idz) ->
    @idzF idz, (z) -> z % 2 is 0

  male: (idz) ->
    @idzF idz, (z) -> z % 2 is 1


  # A combined report of all the possible confines,
  # or else of specified schemes,
  # given a list (i.e. array) of [representation, portion] arrays.
  confines: (list, schemes) ->
    results = []
    for c in list
      several = {}
      previous = undefined
      where = "#{c[0]},#{c[1]}"
      several[where] = {}
      for key, value of @id(c[0]).confines.variants [c[0], c[1]]
        name = value.attributes.name
        if name isnt previous
          several[where][name] = [key]
        else
          several[where][name].push key
        previous = name
      results.push several
    results


module.exports = Zodiac


_ = require 'underscore'


class Degrees

  # A Factory Method Class
  of: (given , base = true) ->
    switch base
      when true then new DegreesBase given
      when 'lon', 'longitude' then new CelestialLongitude given
      else throw "Unknown kind of #{base} degrees."


  # Alias for `@of x, 'lon'` - nice, short, consistent.
  lon: (given, rep) ->
    # Takes an optional representation - 1 for the Ram to 12 for the Fishes.
    if rep?
      if _.isNumber(rep) and 1 <= rep <= 12
        rep = Math.floor rep
        add = (rep - 1) * 30

        if _.isNumber given then given += add
        else if _.isArray given and _.isNumber given[0] then given[0] += add

        # The degrees and representation must be numbers / valid.
        else throw "The given #{given} degrees can't be added to."
      else throw "Invalid representation #{rep}."

    @of given, 'lon'

# Sometimes using more than one degrees instance within this module too.
degrees = new Degrees


class DegreesBase

  # Unacceptable initial value.
  dec: NaN

  # Requirements to be overriden by sub-classes as needed.
  abs: false # must be / remain absolute (i.e. a positive value)

  # Ensuring a `@dec` (decimal degrees) number to work with.
  constructor: (@given) ->

    if _.isNumber @given then @dec = @given

    # DMS: `[degrees]` or `[degrees, minutes]` or `[degrees, minutes, seconds]`.
    # Note: chain-call @neg to get a negative @dec from dms.
    # All of the degrees, minutes or seconds are being taken as absolute values.
    # TODO: consider taking decimal degrees or minutes, even through the array?
    else if _.isArray @given
      unless 1 <= @given.length <= 3
        throw "The given array must at least have degrees, and at most seconds."
      # TODO: figure out why the following validation isn't working:

      #     unless _.all @given, (x) -> _.isNumber x
      #       throw "Expecting the given array #{@given} to be all-number(s)."

      # Note: integers are expected, discarding aything after the decimal.
      @dec =  Math.floor(Math.abs @given[0])
      @dec += Math.floor(Math.abs @given[1]) / 60   if @given.length > 1 # mins
      @dec += Math.floor(Math.abs @given[2]) / 3600 if @given.length > 2 # secs

    else throw "Unexpected '#{typeof(@given)}' type of degrees given."

    # The positive (i.e. absolute) angle - whole int or decimal.
    if @abs then @dec = Math.abs @dec

  # Ensures the degrees are negative.  Useful for geo-coordinates.
  # This was introduced for easier instantiation with a dms array.
  # The @pos opposite could also be added, but that means variable degrees...
  # So far this is the only method besides the constructor(s) that modify @dec.
  # Therefore a one-time-deal without undo.
  neg: ->
    unless @abs then @dec = 0 - Math.abs @dec
    @


  # Just so one can get the decimal degrees with a method call rather than
  # with `@deg` (the only property).  So that to have less of special cases...
  # See CelestialLongitude.representation('the') as an example of wanting more.
  the: -> @dec

  # Radians.
  rad: ->
    @dec * Math.PI / 180

  # Array of [sign, degrees, minutes, seconds] for the standard acronym.
  # Note: that we can't do fractional seconds (as a result of not taking them).
  dms: ->
    # Empty string for plus will make it easier to display.
    n = if @dec < 0 then '-' else ''
    dec = Math.abs @dec
    d = Math.floor  dec
    m = Math.floor((dec * 60)   % 60) # 0 <= m < 60
    s = Math.floor((dec * 3600) % 60) # 0 <= s < 60
    [ n, d, m, s ]

  # A string (with unicode characters after the degrees, minutes and seconds).
  # Fist, but not least, it starts with '-' (minus) if negative.
  str: ->
    [ n, d, m, s ] = @dms()
    "#{n}#{d}\u00B0#{m}\u2032#{s}\u2033"

  unimplemented: (method) ->
    # `mod x` = degrees % modulo <br/>
    # `num n` = convert to the n-th harmonic <br/>
    throw "The wanted '#{method}' method is not implemented yet."


class CelestialLongitude extends DegreesBase

  # See DegreesBase.
  abs: true # absolutely always positive

  # These are only for rep-based longitude, though alignment could be refactored
  # for BaseDegrees as well - need to take into account variation of 1-3 digits.
  aligns: false # set filler character to ' ' or '0' for dms() / str() alignment
  representations: ['♈', '♉', '♊', '♋', '♌', '♍', '♎', '♏', '♐', '♑', '♒', '♓']

  # Longitude degrees are special.
  constructor: (@given) ->
    super @given

    # Ensure [0..360] range, however the pure 0 can't be had.
    # It throws off various calculations, think about doing the same for base...
    # unless @dec is 0 # the only way to have 0 is be given a 0 (no longer true)
    @dec %= 360 # smaller modulos can be done with `mod n` modification
    @dec = 360 if @dec is 0 # exact multiples of 360 equal 360 degrees, again


  # Note that @rep aligns by default.  Set to '' (empty string) if not wanted.
  align: (fill = ' ') ->
    fill = "#{fill}" if _.isNumber fill # so that 0 doesn't have to be quoted
    @aligns = fill # take any value, but the useful are 0, space, '' or false
    @ # chain-able

  # Longitude @dms function is special:
  # * it cannot be negative (so it discards the sign)
  # * it can be aligned with a prepended character - the [d,m,s] become strings
  # The @aligns filling must be set (best by pre-chaining call of @align) and
  # is consumed / cleared with @dms() use.
  dms: ->
    [n, d, m, s] = super()
    if _.isString(@aligns)
      @aligns = @aligns.charAt(0) if @aligns.length > 1
      d = "#{@aligns}#{d}" if d < 10
      m = "#{@aligns}#{m}" if m < 10
      s = "#{@aligns}#{s}" if s < 10
    @aligns = false
    [d, m, s]


  # Is portion (or degree in modern parlance).
  top: ->
    portion = Math.ceil @dec
    portion = 360 if portion is 0 # there is no zero portion (= whole circle)
    portion

  portion: ->
    @top()


  # The 1 to 12 for image / representation (modern "sign" number).
  # Request more and get a representation-first array, followed by that more,
  # where more is a string that matches a method name (e.g. 'top', 'dms')
  # for further getting the rest of the @dec degrees in a representation context.
  rep: (more) ->
    rep = if @dec is 0 or @dec is 360 then 12 else Math.ceil(@dec / 30)

    switch more
      when undefined then rep
      when "sym" then @representations[rep - 1]
      when "str"
        rest = @dec - (rep - 1) * 30
        # Pass on & reset the @aligns, or else align by default if not set.
        # The usual false is ignored - so use blank '' in order to not align.
        [a, @aligns] = [(if _.isString(@aligns) then @aligns else null), false]
        [ d, m, s ] = degrees.lon(rest).align(a).dms()
        "#{@representations[rep - 1]}  #{d}\u00B0#{m}\u2032#{s}\u2033"
      when "the", "top" then [rep, (@[more]() - (rep - 1) * 30)]
      else throw "Unsupported: rep('#{more}')"

  representation: (more) ->
    @rep(more)


  # The 12th part higher-level representation (1 to 12 again).
  _12: (exact = false) ->
    # is p12: -> #better?
    @unimplemented('p12')


module.exports = degrees


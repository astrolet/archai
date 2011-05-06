ut      = require("ut")
_       = require("massagist")._
Geo     = require("geoutils").Geo
LatLon  = require("geoutils").LatLon

class Gaia

  pinpoint: (where) ->
    if where instanceof String
      # TODO: should this assume a valid string?
      [@lat, @lon] = where.split ","
      where
    else if where instanceof Object
      if where.lat? and where.lon?
        # TODO: convert to floats (if needed)
        @lat = where.lat # y
        @lon = where.lon # x
      else
        # Python is ok with NaN (undefined = no good)
        @lat = NaN
        @lon = NaN
      "#{@lat},#{@lon}" # TODO: is this ok for NaNs?
    else
      console.log "Unexpected kind of where: #{where}"
      # process.exit # TODO: error handling?

  timezone: (at) ->
    # TODO: get with api.simpelgeo.com ...
    "+02:00"

  constructor: (where, moment) ->
    @at = this.pinpoint(where) # where at - the point (of geo-location on earth)
    @tz = this.timezone(@at) # timezone depends on the historical daylight saving time at location

    # time validation: format / defaults
    # http://en.wikipedia.org/wiki/ISO-8601
    if moment?
      unless ut.isoMatchFormat(moment)
        console.log "Invalid date-time format of: #{moment}"
        return
      time = moment
    else
      time = (new Date (new Date Date.now()).toUTCString()).toISOString()

    if _.endsWith(time, "Z")
      # do nothing if utc already provided
      # to set the offset, will need to adjust the time as well
      # time = time.replace /Z$/, @tz
      # TODO: do the math / correction if there is any use for it
    else if offset = ut.isoMatchOffset(time)
      # offset is provided - verify it is correct
      offset = offset.toString()
      unless offset is @tz
        # TODO: is it an error if they don't match?
        console.log "Correcting timezone from #{offset} to #{@tz}"
        time = time.replace offset, @tz
    else
      # local time (the usual) case
      # ends with nothing - append tz offset
      time += @tz

    # TODO: fix the timezone!
    # TODO: test with non-local @tz (e.g. not +02:00) - two differents tests should cover it

    @iso = time
    @time = new Date(time)
    @utc = @time.toISOString();
    @ut = ut.c(@utc)

    ###
    console.log "@iso: #{@iso}"
    console.log "@time: #{@time}"
    console.log "@utc: #{@utc}"

    @date = new Date @time
    console.log "getTimezoneOffset() = #{@date.getTimezoneOffset() / 60}"
    console.log "toString: #{@date.toString()}"
    console.log "toUTCString: #{@date.toUTCString()}"
    console.log "toISOString: #{@date.toISOString()}"
    ###


module.exports = Gaia

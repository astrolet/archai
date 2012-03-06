ut      = require("./ut")
_       = require("massagist")._
Geo     = require("geoutils").Geo
LatLon  = require("geoutils").LatLon


# ## The Where & When on Earth
class Gaia


  # #### Ensure latitude & longitude are present.
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
      # TODO: is this ok for NaNs?
      "#{@lat},#{@lon}"
    else
      # TODO: error handling (process.exit)?
      console.log "Unexpected kind of where: #{where}"


  # #### Get the correct (historical) timezone.
  timezone: (at) ->
    # TODO: api.simpelgeo.com was going to have it...
    "+02:00"

  # #### A Gaia
  constructor: (where, moment) ->
    # Where at - the point (of geo-location on earth).
    @at = this.pinpoint(where)
    # Timezone depends on the historical daylight saving time at location.
    @tz = this.timezone(@at)

    # Time validation: [ISO-8601](http://en.wikipedia.org/wiki/ISO-8601) format / defaults
    if moment?
      unless ut.isoMatchFormat(moment)
        console.log "Invalid date-time format of: #{moment}"
        return
      time = moment
    else
      time = (new Date (new Date Date.now()).toUTCString()).toISOString()

    if _.endsWith(time, "Z")
      # Do nothing if utc already provided.
      # To set the offset, will need to adjust the time as well.<br/>
      # `time = time.replace /Z$/, @tz`<br/>
      # TODO: do the math / correction if there is any use for it
    else if offset = ut.isoMatchOffset(time)
      # Offset is provided, verify it is correct.
      offset = offset.toString()
      unless offset is @tz
        # TODO: is it an error if they don't match?
        console.log "Correcting timezone from #{offset} to #{@tz}"
        time = time.replace offset, @tz
    else
      # Local time (the usual) case ends with nothing - append tz offset.
      time += @tz

    @iso = time
    @time = new Date(time)
    @utc = @time.toISOString();
    @ut = ut.c(@utc)

    # TODO: fix the timezone!<br/>
    # TODO: test with non-local @tz (e.g. not +02:00 for Varna, BG)

#<!--
#   console.log "@iso: #{@iso}"
#   console.log "@time: #{@time}"
#   console.log "@utc: #{@utc}"
#
#   @date = new Date @time
#   console.log "getTimezoneOffset() = #{@date.getTimezoneOffset() / 60}"
#   console.log "toString: #{@date.toString()}"
#   console.log "toUTCString: #{@date.toUTCString()}"
#   console.log "toISOString: #{@date.toISOString()}"
#-->

# #### Gaia module
module.exports = Gaia

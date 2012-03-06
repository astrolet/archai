# ## Universal Time Creator

# These regular expressions were borrowed
# from a [smart source](http://frugalcoder.us/post/2010/01/07/EcmaScript-5s-Date-Extensions.aspx).

iso8601Offset = /[-+]\d{2}:\d{2}$/
iso8601Format = /^(\d{4})-(\d{2})-(\d{2})((([T ](\d{2}):(\d{2})(:(\d{2})(\.(\d+))?)?)?)?)?(([-+])(\d{2}):(\d{2}))?(Z)?$/

# Checks if a string is in ISO-8601 format.

exports.isoMatchFormat = (iso) ->
  iso.match iso8601Format

# Checks if a string ends with ISO-8601 time offset.

exports.isoMatchOffset = (iso) ->
  iso.match iso8601Offset

# Expects UTC time as ISO-8601 String, or defaults to Date.now();
# Converts utc to the equivalent universal time pieces
# that `utc_to_jd` (the swiss ephemeris function) expects.
# Ready for calling [precious](http://astrolet.github.com/precious) with.

exports.c = (utc = (new Date Date.now()).toISOString()) ->
  t = utc.match(iso8601Format)
  seconds = t[10] || 0 # optional
  seconds+= ".#{t[12]}" if t[12]? # floating point precise
  return [ Number(t[1])
         , Number(t[2])
         , Number(t[3])
         , Number(t[7])
         , Number(t[8])
         , Number(seconds)
         , 1 # Gregorian flag - correct?
         ]

# Node gets the getUTCMonth() wrong (-1), so don't trust it:
#
#     time = new Date utc
#     [ time.getUTCFullYear()
#     , time.getUTCMonth()
#     , time.getUTCDate()
#     , time.getUTCHours()
#     , time.getUTCMinutes()
#     , "#{time.getUTCSeconds()}.#{time.getUTCMilliseconds()}"
#     ]
#
# TODO: ask the author of DateExtensions.js (the regex) why he also subtracts 1 from month.
# Is it about a v8 / node.js issue?

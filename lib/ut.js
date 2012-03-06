(function() {
  var iso8601Format, iso8601Offset;

  iso8601Offset = /[-+]\d{2}:\d{2}$/;

  iso8601Format = /^(\d{4})-(\d{2})-(\d{2})((([T ](\d{2}):(\d{2})(:(\d{2})(\.(\d+))?)?)?)?)?(([-+])(\d{2}):(\d{2}))?(Z)?$/;

  exports.isoMatchFormat = function(iso) {
    return iso.match(iso8601Format);
  };

  exports.isoMatchOffset = function(iso) {
    return iso.match(iso8601Offset);
  };

  exports.c = function(utc) {
    var seconds, t;
    if (utc == null) utc = (new Date(Date.now())).toISOString();
    t = utc.match(iso8601Format);
    seconds = t[10] || 0;
    if (t[12] != null) seconds += "." + t[12];
    return [Number(t[1]), Number(t[2]), Number(t[3]), Number(t[7]), Number(t[8]), Number(seconds), 1];
  };

}).call(this);

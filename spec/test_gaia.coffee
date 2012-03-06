vows =    require "vows"
assert =  require "assert"
Gaia =    require "../lib/gaia"

input =
  geo:
    lat: "43N13"
    lon: "27E55"
  time: "1974-06-30T23:45:00"

output =
  at: "43N13,27E55"
  tz: "+02:00"
  iso: "1974-06-30T23:45:00+02:00"
  utc: "1974-06-30T21:45:00.000Z"
  time: "Sun Jun 30 1974 23:45:00 GMT+0200 (EET)"

vows.describe("Gaia").addBatch(

  "an instance without moment":
    topic: ->
      new Gaia input["geo"]

    "is about the present now": (gaia) ->
      # NOTE: now moves on all the time, it's almost the same ever after
      assert.instanceOf gaia.time, Date
      assert.isString   gaia.utc
      assert.isString   gaia.iso

      ###
      assert.equal output["at"],      gaia.at
      assert.equal output["tz"],      gaia.tz
      assert.equal output["iso"],     gaia.iso
      assert.equal output["utc"],     gaia.utc
      assert.equal output["time"],    gaia.time
      ###

).export module

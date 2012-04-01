coordinates = require "../../lib/coordinates"

describe "CelestialCoordinates", ->

  describe "instantiation", ->

    it "of Ecliptic's CelestialLongitude and default latitude degrees of 0", ->
      five = coordinates.of 5
      five.lon.dec.should.eql 5
      five.lat.dec.should.eql 0

    it "of given object with lon & lat keys, ecliptical() equals the corresponding degrees pair", ->
      [lon, lat] = coordinates.of(0, 1).ecliptical()
      coordinates.of({"lon": 0, "lat": 1}).ecliptical().should.eql [lon, lat]
      lon.dec.should.eql 360
      lat.dec.should.eql 1


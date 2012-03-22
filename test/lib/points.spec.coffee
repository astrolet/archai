Points = require "../../lib/points"

describe "Points", ->


  describe "instantiation of", ->

    it "no points or empty array + @a() gracefully returns the '-' id for none", ->
      points = new Points []
      points.length.should.eql 0
      points.a().get('id').should.eql '-'

    it "just a point with an Object (any id string + longitude) that can be got with @a()", ->
      point = (new Points {"id": "Stellium", "lon": 9}).a()
      point.get('id').should.eql "Stellium"
      point.get('lon').should.eql 9
      point.get('lat').should.eql 0


  describe "change of coordinates", ->

    it "changes the @at on 'lon' or 'lat' attribute change", ->
      point = (new Points id: "c", lon: 1, lat: -1).a()
      point.set lon: 3, lat: 2
      point.at.lon.dec.should.eql 3
      point.at.lat.dec.should.eql 2


Points = require "../../lib/points"

describe "Points", ->


  describe "instantiation of", ->

    it "handles no points or empty array + @a() gracefully returns the '-' id for none", ->
      points = new Points []
      points.length.should.eql 0
      points.a().get('id').should.eql '-'

    it "just a point with an Object (any id string + longitude) that can be got with @a()", ->
      point = (new Points {"id": "Stellium", "lon": 9}).a()
      point.get('id').should.eql "Stellium"
      point.get('lon').should.eql 9
      point.get('lat').should.eql 0


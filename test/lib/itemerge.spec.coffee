Itemerge = require "../../lib/itemerge"

describe "Itemerge:", ->

  describe "construction", ->

    it "can make a plain Itemerge (without any special traits)", ->
      itemerge = new Itemerge
      itemerge.planet.should.eql false
      itemerge.dispositor.should.eql false

    it "can make it be as: 'planet' #string option", ->
      itemerge = new Itemerge traits: ['planet']
      itemerge.planet.should.eql true

    it "can make a planet that's also a dispositor", ->
      itemerge = new Itemerge traits: ['planet', 'dispositor']
      itemerge.planet.should.eql true
      itemerge.dispositor.should.eql true


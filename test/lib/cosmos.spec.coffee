cosmos = new (require "../../lib/cosmos")
_ = require "underscore"
inspect = (require "eyes").inspector()
assert  = (require "chai").assert
should  = (require "chai").should


describe "Cosmos:", ->

  describe "built with defaults -", ->

    it "has an 'element' attribute among many", ->
      assert cosmos.zodiac.id(12).get('element') is "W"


  describe "dispositor defaults -", ->

    it "has at least one 'domicile' dispositor", ->
      theFishes = cosmos.zodiac.id 12
      assert theFishes.get('domicile') is "JU"
      assert theFishes.domicile().get('id') is "JU"

    it "has at least one 'exaltation' dispositor", ->
      theCrab = cosmos.zodiac.id 4
      assert theCrab.get('exaltation') is "JU"
      assert theCrab.exaltation().get('id') is "JU"

    it "the Crab has all the three Trigon Lords set", ->
      theCrab = cosmos.zodiac.id 4
      theCrab.trigons.pluck('lord').should.eql ['MO', 'VE', 'MA']
      assert theCrab.trigons.day().get('id') is 'VE'
      assert theCrab.trigons.night().get('id') is 'MA'
      assert theCrab.trigons.cooperating().get('id') is 'MO'

    it "there are dispositors that aren't planets, i.e. the exalted nodes", ->
      assert cosmos.zodiac.id(3).exaltation().get('id') is "NN"
      assert cosmos.zodiac.id(9).exaltation().get('id') is "SN"

    it "can handle the no exaltation dispositors, getting the *none* item", ->
      cosmos.zodiac.id(8).exaltation().should.eql cosmos.ensemble.getNone()

    it "can get the Confines Lords, given certain Representation portions", ->
      # These aren't boundary-testing portions, but rather Orlin's verification.
      rpd = # representation, portion, dispositor (of confines, of-course)
        [ [ 1,  5, "JU"]
        , [ 3,  6, "ME"]
        , [ 3, 20, "MA"]
        , [ 4,  9, "VE"]
        , [ 4, 25, "JU"]
        , [ 5, 14, "SA"]
        , [ 5, 24, "ME"]
        , [ 6, 19, "JU"]
        , [ 7,  5, "SA"]
        , [ 7, 24, "VE"]
        , [ 7, 29, "MA"]
        , [ 8, 15, "ME"]
        , [ 8, 29, "SA"]
        , [ 9,  8, "JU"]
        , [ 9, 14, "VE"]
        , [ 9, 20, "ME"]
        , [10,  3, "ME"]
        , [10, 13, "JU"]
        , [10, 17, "VE"]
        , [12, 18, "ME"]
        ]

      for c in rpd
        # Explicitly check for Egyptian Confines.
        assert cosmos.zodiac.id(c[0]).confines.followed([c[0], c[1]], 'EC').get('id') is c[2]

      # inspect cosmos.zodiac.confines rpd


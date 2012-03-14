degrees = require "../../lib/degrees"

describe 'call degrees:', ->

  describe "when wanted (default) is 'dec', the given", ->

    it 'can take 1 whole number (i.e. an integer)', ->
      degrees.of(1).dec.should.eql 1

    it '0 of base degrees is ok and stays 0', ->
      degrees.of(0).dec.should.eql 0

    it '0 longitude degrees, in contrast, become 360', ->
      degrees.lon(0).dec.should.eql 360

    it '360 longitude is left unchanged', ->
      degrees.lon(360).dec.should.eql 360

    it '720 longitude is same as 360 (its exact multiple)', ->
      degrees.lon(720).dec.should.eql 360

    it '-5 (negative longitude), is its absolute (i.e. positive) value', ->
      degrees.lon(-5).dec.should.eql 5

    it 'longitude (for which `@abs is true`) cannot be negated', ->
      degrees.lon(5).neg().dec.should.eql 5

    it 'plain degrees, by default, can be / become negative', ->
      degrees.of(-12).dec.should.eql -12
      degrees.of(12).neg().dec.should.eql -12

    it 'negating already negative degrees has no effect - still negative', ->
      degrees.of(-13).neg().dec.should.eql -13

    it 'decimal degrees value is preserved', ->
      degrees.of(7.89).dec.should.eql 7.89

    it 'decimal degrees value can also be got via `the()` - a "getter"', ->
      degrees.of(1.23).the().should.eql 1.23


  describe "when [d], [d,m] or [d,m,s] are given", ->

    it "[1], [1, 2], [1, 2, 3] a degree plus optional minutes, seconds", ->
      degrees.of([1]).dms().should.eql ['', 1, 0, 0]
      degrees.of([1, 2]).dms().should.eql ['', 1, 2, 0]
      degrees.of([1, 2, 3]).dms().should.eql ['', 1, 2, 3]

    it "discards fractions from the dms array - javascript math issues", ->
      degrees.lon([45.7, 30.5, 1]).dms().should.eql [45, 30, 1]
      degrees.lon([117, 23, 23.32]).dms().should.eql [117, 23, 23]

    it "returns '-' (i.e. minus) for negative dms (at the 0 position)", ->
      degrees.of([120, 39, 59]).neg().dms().should.eql ['-', 120, 39, 59]

    it "can get a nice / easy string for degrees, minutes and seconds", ->
      degrees.of([74, 0, 45]).neg().str().should.eql "-74°0′45″"

      # TODO: make the following test pass!
      # console.log degrees.of([8, 42, 30]).neg().the()
      # degrees.of([8, 42, 30]).neg().str().should.eql "-8°42′30″"


  describe "when wanted longitude is 'top', the given", ->

    it "0 is 360 (the last portion of a whole circle)", ->
      degrees.of(0, 'lon').top().should.eql 360
      degrees.of(360, 'lon').top().should.eql 360

    it "30 exact as the next representation boundary", ->
      degrees.of(30, 'lon').top().should.eql 30

    it "360.9 is portion 1", ->
      degrees.of(360.9, 'lon').top().should.eql 1


  describe "when wanted is 'rad', the given", ->

    it "180 degrees equal the PI constant in radians", ->
      degrees.of(180).rad().should.eql Math.PI


  describe "when wanted longitude is 'rep' for representation", ->

    it "0 degrees, just like top returns 12 for the Fishes", ->
      degrees.of(0, 'lon').representation().should.eql 12

    it "360 degrees (special case) is 12 for the Fishes", ->
      degrees.of(360, 'lon').representation().should.eql 12

    it "0 or 360 degrees both = the last portion (impossible 0)", ->
      degrees.of(0, 'lon').rep('top').should.eql [12, 30]
      degrees.of(360, 'lon').rep('top').should.eql [12, 30]

    it "0 degrees of a representation is 30 of the previous one", ->
      degrees.lon(0, 2).rep('the').should.eql [1, 30] # 0 Taurus is 30 Aries
      degrees.lon(0, 1).rep('the').should.eql [12, 30] # 0 Aries is 30 Pisces
      degrees.lon(0, 12).rep('the').should.eql [11, 30] # 0 Pisces: 30 Aquarius

    it "60 being the exact last degree of the Bull is the Bull", ->
      degrees.of(60, 'lon').rep('top').should.eql [2, 30]

    it "65.5 degrees is the 3rd representation, plus portion 6", ->
      degrees.of(65.5, 'lon').rep('top').should.eql [3, 6]

    it "first possible portion (of the first image)", ->
      degrees.of(1, 'lon').rep('top').should.eql [1, 1]

    it "last portion of any image, e.g. the Crab", ->
      degrees.of(120, 'lon').rep('top').should.eql [4, 30]

    it "59 degrees + some minutes = the last portion of an image", ->
      degrees.of(59.23, 'lon').rep('top').should.eql [2, 30]

    it 'the crab (4), 9 portions - with the lon method helper', ->
      degrees.lon(8.5, 4).rep('top').should.eql [4, 9]

    it 'calling it with "sym" returns its unicode symbol', ->
      degrees.lon(1).rep('sym').should.eql '♈'
      degrees.lon(120).rep('sym').should.eql '♋'
      degrees.lon(360).rep('sym').should.eql '♓'


  describe "longitude representation-relative dms", ->

    it 'can show the symbol, followed by the remaining dms string default', ->
      degrees.lon(98.60114469380143).rep('str').should.eql '♋   8°36′ 4″'

    it 'can override the default alignment, by asking to not align at all', ->
      degrees.lon(98.60114469380143).align('').rep('str').should.eql '♋  8°36′4″'

    it 'can align using 0 (number padding) instead of the default (space)', ->
      degrees.lon(98.60114469380143).align('0').rep('str').should.eql '♋  08°36′04″'


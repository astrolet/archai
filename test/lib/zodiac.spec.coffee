zodiac = new (require "../../lib/zodiac")
assert = (require "chai").assert
should = (require "chai").should


describe "Zodiac:", ->

  describe "construction (English Hindsight defaults) -", ->

    it "get name of the 1st representation, as intuitive as @at(1) up to the 11th", ->
      assert zodiac.at(1).get('name') is 'Ram'

    it "get name of the 12th representation, @at(0) leading the 1st, same as @id(12) the special case", ->
      assert zodiac.at(0).get('name') is zodiac.id(12).get('name')

  describe "gender (+ names)", ->

    it "can get all the female representations - in idz order", ->
      zodiac.female().should.eql [2, 4, 6, 8, 10, 12]

    it "can pick the Crab as female (among males)", ->
      zodiac.female([3, 4, 5]).should.eql [4]

    it "can confirm the Balance is male, given a number without array", ->
      zodiac.male(7).should.eql [7]

    it "without chaining - get the names the Lion and the Twins based on (male) gender", ->
      # also, this doesn't look good - maybe add @names (for starters)
      (zodiac.names zodiac.male [6, 4, 5, 3]).should.eql ['Lion', 'Twins']

  describe "use of languages other than English (e.g. Bulgarian)", ->

    it "can translate to the specified language and chain methods", ->
      assert zodiac.translate('bg').id(5).get('name') is 'Лъв'

    it "the language stays what it has been translated to", ->
      assert zodiac.id(4).get('name') is 'Рак'

    it "can get the Crab in Greek too", ->
      assert zodiac.translate('el').id(4).get('name') is 'Καρκίνος'


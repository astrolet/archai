ensemble = new (require "../../lib/ensemble")
_ = require "underscore"

describe "Ensemble:", ->

  describe "the defaults include", ->

    it "all the planets (icluding outers) and dispositors (use Hindsight names, if available)", ->
      seven = [ 'Selene'
              , 'Hermes'
              , 'Aphrodite'
              , 'Helios'
              , 'Ares'
              , 'Zeus'
              , 'Kronos'
              ]
      planets = _.union seven, [ 'Uranus', 'Neptune', 'Pluto' ]
      dispositors = _.union seven, [ 'North Node', 'South Node' ]

      ensemble.seven().pluck('name').should.eql seven
      ensemble.planets().pluck('name').should.eql planets
      ensemble.dispositors().pluck('name').should.eql dispositors


  describe "use of languages other than English (e.g. Bulgarian)", ->

    it "can translate to the specified language and chain methods", ->
      ensemble.translate('bg').get('SO').get('name').should.eql 'Хелиос'

    it "the language stays what it has been translated to", ->
      ensemble.get('MO').get('name').should.eql 'Селена'

    it "can get the modern Венера", ->
      ensemble.translate('bg', 'm').get('VE').get('name').should.eql 'Венера'

    it "knows the name of the love goddess in Greek too", ->
      ensemble.translate('el').get('VE').get('name').should.eql 'Ἀφροδίτη'

    it "currently not translated words are mixed in as English", ->
      ensemble.getUnknown().get('name').should.eql "Unknown"


  describe "can also get an item", ->

    it "with a sid (i.e. the Swiss Ephemeris ID) - either Number or its String equivalent", ->
      ensemble.sid(0).get('id').should.eql 'SO'
      ensemble.sid("0").get('id').should.eql 'SO'

    it "with invalid sid - the result is @getUnknown()", ->
      ensemble.sid(-1).get('id').should.eql '?'


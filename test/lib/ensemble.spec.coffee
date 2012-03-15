ensemble = new (require "../../lib/ensemble")
_ = require "underscore"

describe "Ensemble:", ->

  describe "the defaults include", ->

    it "all the planets and dispositors (check for their Hindsight names)", ->
      planets = [ 'Selene',
                  'Hermes',
                  'Aphrodite',
                  'Helios',
                  'Ares',
                  'Zeus',
                  'Kronos' ]
      dispositors = _.union planets, [ 'North Node', 'South Node' ]
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


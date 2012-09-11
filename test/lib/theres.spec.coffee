_ = require 'underscore'
assert = require 'assert'

theres = require('../../index').theres()

describe "there's", ->

  describe "index-trait models that", ->

    it "can be got from the Ensemble, i.e. what stuff is made available", ->

      assert _.isArray theres
      assert theres.length > 0
      assert theres[0].name?
      assert theres[0].sid?


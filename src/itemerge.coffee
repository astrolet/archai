_ = require 'underscore'
Backbone = require 'backbone-rel'

# Cosmic / canonical point of interest
# emerging item or merging of a less active one
class Itemerge extends Backbone.RelationalModel

  initialize: (attributes = {}) ->

    for trait in attributes.traits ? []
      _.extend @, traits[trait]

    @planet ?= false
    @dispositor ?= false


traits =
  # The Planets have some special characteristics
  planet:
    planet: true
  # The Planets & Nodes (anything that can be dispositor)
  dispositor:
    dispositor: true


module.exports = Itemerge


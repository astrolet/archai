_ = require "underscore"

# Use this as a mixin for classes that have words to name / translate.
# See _./itemerge.coffee_ as an example of what the nested @words hash is like.

# Suppose an attribute of "name" - quite usual, often the only (necessary).
# Thus expect that `@words.expect is ['name']`, while the actual words data
# must be in conformance with each `@words.data[id][attribute][language]`
# set to a `["Hermes Name", "Modern Name"]` array.

# **`Hermes Name`** is the Hellenistic Astrology (System of Hermes) name.
# If the **`Hermes Name`** is `true`, rather than a string, it means that
# the **`Modern Name`** is equivalent to the original Greek word.
# If it's `null` (with other languages), then it hasn't been revised,
# meaning it's possibly sub-optimal for Hellenistic Astrology use.
# A value of false means it's deemed unfit for Hellenistic Astrology.

# In order to be `@translatable` a collection needs to have its initial data
# in one or more hashes - look at ./itemerge.coffee and how `@planets.the`
# and `@planets.attributes.use` are expected in addition to `@words`.
# There can be more than one initialization hashes, but a single `@words`
# data set for translation - basically the collection as a whole.

# Example usage within the `constructor` / `initialize`:

#     _.extend @, polyglot.ensure
#     @translatable() is true


module.exports = {

  ensure:

    translatable: (inits) ->
      # English words must be present (at least), but also many other things...
      # It's kind of pointless to check for it all.  Perhaps a try / catch - as
      # another way to return `false`.  Another idea: check if anything is to be
      # `push`ed and have that determine the return value.
      if @words? and not _.isEmpty inits
        # Expected instance variables will get defaults if not already set.
        @school ?= "h"
        @language ?= "en"

        # Will this work on the client-side?
        _.extend @, module.exports.methods

        # Initialize the translatable data.
        for init in inits

          # The same translatable attributes must be used across the collection.
          # This isn't immediately obvious, looking at a single init hash.
          for i in [0 .. @words.expect.length - 1]
            expected = @words.expect[i] # the translated key
            filledIn = @words.filler[i] # default, if no translation is present
            sequence = init.the[0].length + i

            init.attributes.use[expected] = sequence

            # If each row's expected item is not in `words.data[{key}][{expect}]`
            # add a default using `words.filler` data
            # from a corresponding array position.
            for row in init.the
              identifier = row[init.attributes.use[init.attributes.key]]
              substitute = row[init.attributes.use[filledIn]] # filled-in value
              @words.data[identifier] ?= {}
              unless @words.data[identifier][expected]?
                # console.log "not found: key '#{identifier}' for '#{expected}'"
                # console.log "using: #{substitute}"
                addition = en: [ false, substitute ]
                @words.data[identifier][expected] = addition

          # It's important to call `@translation` with sorted keys,
          # or else the `@words.data` order must match that of `init.the`.
          i = 0
          for attributes in _.values @translation @language # and further...
               , @school
               , _.pluck(init.the, init.attributes.use[init.attributes.key])

            # Add each attribute (without "key_id", which usually is the "id").
            for attribute, word of attributes
              continue if attribute is "key_id"
              init.the[i].push word
            i++

        true
      else false


  # The following are mixed in through an `if @translatable()` call / (check).
  methods:

    translation: ( language
                 , school
                 , keys = []
                 , select = @words.expect
                 ) ->

      switch @school
        when "h" then position = 0 # hermes (hellenistic hindsight)
        when "m" then position = 1 # modern
        else throw "Unknown '#{@school}' position."

      if _.isEmpty keys then keys = _.keys @words.data
      else
        # Sorted according to `keys` order (intersection does), so `@words.data`
        # can be in any order.
        keys = _.intersection keys, _.keys @words.data

      # The `i` is immediately incremented for `out[i]` use.
      out = []; i = -1
      for key in keys
        out[++i] = { "key_id": key }
        for word in select
          # The English language is used / mixed in for untranslated
          # or partially translated stuff.
          stuff = @words.data[key][word][@language] ? @words.data[key][word]['en']
          if position is 0
            value = stuff[position]
            if _.isString value then out[i][word] = value
            else
              switch value
                # The modern version is `true`, meaning it never deviated from
                # its Hellenistic roots.  Or, in the case of `null` -
                # it's unknown if it will have to be translated.
                # Modern is assumed to be ok for the time being.
                # TODO: null doesn't seem to be picking the data (undefined)!
                when true || null then out[i][word] = stuff[1]
                # The modern version is unacceptable (what `false` means).
                # English default is always available (at least as modern).
                when false
                  out[i][word] = @words.data[key][word]['en'][position]
                  # The English fallback position 0, could be made more elegant.
                  # Probably this whole translation should be refactored,
                  # extracting a tranlateWord function to get in a language or
                  # else call it again for English.
                  unless _.isString out[i][word]
                    out[i][word] = @words.data[key][word]['en'][1]
          # Assuming that every translated language has the modern vocabulary.
          else out[i][word] = stuff[position]

      out


    # Use an optional array of `select` attributes for partial translation.
    translate: (language = @language, school = @school, select) ->

      # The current implementation doesn't force-reload
      # the same language / school (pointless as the data is part of the code).
      if @language isnt language or @school isnt school
        @school = school
        @language = language

        for attributes in @translation @language
                                          , @school
                                          , @pluck('id')
                                          , select

          key = attributes.key_id
          delete attributes.key_id
          # Note that "get" is the default method for the `@words.data` key.
          @[@words.model || 'get'](key).set attributes

      @ # chainable

}


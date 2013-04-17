###

Much of this code and all of the good ideas were taken from the Sugar JS library
Copyright (c) Andrew Plummer, http://sugarjs.com/

Modifications Copyright(c) Gustavo Duarte
 
###

_ = require('underscore')
F = require('./index')
delimiters = ["''", '""', '{}', '[]', '()']

# this is from http://stackoverflow.com/questions/822452/strip-html-from-text-javascript
# I haven't tested it much yet
rgxStripHtml = /<(?:.|\n)*?>/gm

self = {
    delimiters,

    toPlural: (s) -> i.inflect(s, true)

    toSingular: (s) -> i.inflect(s, false)

    tryUpper: (s) -> if _.isString(s) then s.toUpperCase() else s
    tryLower: (s) -> if _.isString(s) then s.toLowerCase() else s

    ###
     * @method spacify()
     * @short Converts camel case, underscores, and hyphens to a properly spaced string.
    ###
    spacify: (s) -> self.underscore(s).replace(/_/g, ' ')

    ###
     * @method underscore()
     * @short Converts hyphens and camel casing to underscores.
     ###
    underscore: (s) ->
      return s
        .replace(/[-\s]+/g, '_')
        .replace(i.acronymRegExp, (fullMatch, acronym, index) ->
            (if index > 0 then '_' else '') + acronym.toLowerCase()
        )
        .replace(/([A-Z\d]+)([A-Z][a-z])/g,'$1_$2')
        .replace(/([a-z\d])([A-Z])/g,'$1_$2')
        .toLowerCase()

    toUpperInitial: (s) ->
        c = s.charAt(0).toUpperCase()
        return if s.length == 1 then c else c + s.slice(1)

    toLowerInitial: (s) ->
        c = s.charAt(0).toLowerCase()
        return if s.length == 1 then c else c + s.slice(1)

    undelimit: (s, args...) ->
        pairs = if args.length > 0 then args else delimiters
        for d in pairs
            if s.charAt(0) == d.charAt(0) && s.charAt(s.length-1) == d.charAt(1)
                return s.slice(1, s.length-1)
        return s

    stripHtml: (s) ->
        F.demandGoodString(s, "s")
        return s.replace(rgxStripHtml, '')

    toCamelCase: (s, first) ->
      return self.underscore(s).replace(/(^|_)([^_]+)/g, (match, pre, word, index) ->
            acronym = i.acronyms[word]
            toUpperInitial = first != false || index > 0
            
            if(acronym)
                return if toUpperInitial then acronym else acronym.toLowerCase()

            return if toUpperInitial then self.toUpperInitial(word) else word
      )

    # Thanks to Jason Orendorff
    # http://stackoverflow.com/questions/1877475/repeat-character-n-times
    repeat: (str, n) -> Array(n+1).join(str)

    padLeft: (s, length, pad = ' ') ->
        s = s.toString()
        return s if s.length >= length
        return self.repeat(pad, length - s.length) + s
}

i = require('./inflector')
module.exports = self

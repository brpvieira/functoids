_ = require('underscore')

F = require('./index')

self = {
    # Written by Tim Down, http://www.timdown.co.uk in this awesome answer:
    # http://stackoverflow.com/questions/3108986/gaussian-bankers-rounding-in-javascript 
    evenRound: (num, decimalPlaces) ->
        unless F.isGoodNumber(num)
            F.throw("Argument num must be a valid number, but was '#{num}'")

        d = decimalPlaces || 0
        m = Math.pow(10, d)
        n = +(if d then num * m else num).toFixed(8)
        i = Math.floor(n)
        f = n - i
        if (f == 0.5)
            r = if (i % 2 == 0) then i else i + 1
        else
            r = Math.round(n)

        return if d then r / m else r
}

module.exports = self

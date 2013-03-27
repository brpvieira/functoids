_ = require('underscore')

argumentError = (demand, argName, customMsg) ->
    s = [
        "Argument "
        if argName? then "'#{argName}' " else ""
        "must "
        customMsg ? demand
    ].join('')
        
    throw new Error(s)

rgxNonWhitespace = /\S/

validator = {
    demandNotNil: (a, argName, customMsg) ->
        return true if a?
        argumentError("not be null or undefined", argName, customMsg)

    demandArray: (a, argName, customMsg) ->
        return true if _.isArray(a)
        argumentError("be an array", argName, customMsg)

    demandNonEmptyArray: (a, argName, customMsg) ->
        return true if _.isArray(a) && !_.isEmpty(a)
        argumentError("be a non-empty array", argName, customMsg)

    demandGoodArray: (a, argName, customMsg) ->
        return true if validator.isGoodArray(a)
        argumentError("be a non-empty array free of nil elements", argName, customMsg)

    demandArrayOfStrings: (a, argName, customMsg) ->
        return true if validator.isArrayOfStrings(a)
        argumentError("be an array of strings", argName, customMsg)

    demandArrayOfGoodStrings: (a, argName, customMsg) ->
        return true if validator.isArrayOfGoodStrings(a)
        argumentError("be an array of non-empty, non-all-whitespace strings", argName, customMsg)

    demandArrayOfGoodNumbers: (a, argName, customMsg) ->
        return true if validator.isArrayOfGoodNumbers(a)
        argumentError("be an array of non-infinity, non-NaN numbers", argName, customMsg)

    demandObject: (o, argName, customMsg) ->
        return true if _.isObject(o)
        argumentError("be an object", argName, customMsg)

    demandGoodObject: (o, argName, customMsg) ->
        return true if validator.isGoodObject(o)
        argumentError("be a defined, non-empty object", argName, customMsg)

    demandString: (s, argName, customMsg) ->
        return true if _.isString(s)
        argumentError("be a string", argName, customMsg)

    demandGoodString: (s, argName, customMsg) ->
        return true if validator.isGoodString(s)
        argumentError("be a non-empty, non-all-whitespace string", argName, customMsg)

    demandNumber: (n, argName, customMsg) ->
        return true if _.isNumber(n)
        argumentError("be a number", argName, customMsg)

    demandGoodNumber: (n, argName, customMsg) ->
        return true if validator.isGoodNumber(n)
        argumentError("be a number", argName, customMsg)

    # See I've already waited too long
    # And all my hope is gone
    demandDate: (d, argName, customMsg) ->
        return true if _.isDate(d)
        argumentError("be a Date", argName, customMsg)

    isGoodObject: (a) -> _.isObject(a) && !_.isEmpty(a)

    isGoodArray: (a) ->
        return false unless _.isArray(a) && !_.isEmpty(a)

        for e in a
            return false unless e?

        return true

    isGoodString: (s) ->
        return false unless _.isString(s) && s.length > 0
        return rgxNonWhitespace.test(s)

    isGoodNumber: (n) ->
        return _.isNumber(n) && _.isFinite(n) && !isNaN(n)

    isArrayOfStrings: (a) ->
        return false unless _.isArray(a)
        for s in a
            return false unless _.isString(s)
        return true

    isArrayOfGoodStrings: (a) ->
        return false unless _.isArray(a)
        for s in a
            return false unless validator.isGoodString(s)
        return true

    isArrayOfGoodNumbers: (a) ->
        return false unless _.isArray(a)
        for n in a
            return false unless validator.isGoodNumber(n)
        return true
}

validator.demandNonEmptyObject = validator.demandGoodObject

module.exports = validator

_ = require('underscore')

argumentError = (demand, argName, customMsg) ->
    s = [
        "Argument "
        if argName? then "'#{argName}' " else ""
        "must "
        customMsg ? demand
    ].join('')
        
    throw new Error(s)

self = {
    demandNotNil: (a, argName, customMsg) ->
        return true if a?
        argumentError("not be null or undefined", argName, customMsg)

    demandArray: (a, argName, customMsg) ->
        return true if _.isArray(a)
        argumentError("be an array", argName, customMsg)

    demandNonEmptyArray: (a, argName, customMsg) ->
        return true if _.isArray(a) && !_.isEmpty(a)
        argumentError("be a non-empty array", argName, customMsg)

    demandObject: (o, argName, customMsg) ->
        return true if _.isObject(o)
        argumentError("be an object", argName, customMsg)

    demandNonEmptyObject: (o, argName, customMsg) ->
        return true if _.isObject(o) && !_.isEmpty(o)
        argumentError("be a non-empty object", argName, customMsg)

    demandString: (s, argName, customMsg) ->
        return true if _.isString(s)
        argumentError("be a string", argName, customMsg)

    demandNumber: (n, argName, customMsg) ->
        return true if _.isNumber(n)
        argumentError("be a number", argName, customMsg)

    # See I've already waited too long
    # And all my hope is gone
    demandDate: (d, argName, customMsg) ->
        return true if _.isDate(d)
        argumentError("be a Date", argName, customMsg)
}

module.exports = self

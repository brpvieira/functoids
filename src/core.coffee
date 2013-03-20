_ = require('underscore')

self = {
    isGood: (o) ->
        return false unless o?
        return if _.isString(o) then o.trim().length > 0 else true

    isBad: (o) -> !self.isGood(o)
}

module.exports = self

_ = require('underscore')

self = {
    throw: () ->
        msg = Array::join.call(arguments, ' ')
        throw new Error(msg)
}

module.exports = self

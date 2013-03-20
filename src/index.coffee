_ = require('underscore')
core = require('./core')
array = require('./array')
s = require('./string')

m = _.extend({}, core, array, s)
_.mixin(m)
_.inflector = require('./inflector')

module.exports = _

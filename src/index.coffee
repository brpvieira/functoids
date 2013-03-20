_ = require('underscore')
core = require('./core')
array = require('./array')
s = require('./string')

_.extend(exports, core, array, s)
exports.inflector = require('./inflector')

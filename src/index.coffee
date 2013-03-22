_ = require('underscore')
core = require('./core')
array = require('./array')
s = require('./string')
v = require('./validation')

_.extend(exports, core, array, s, v)
exports.inflector = require('./inflector')

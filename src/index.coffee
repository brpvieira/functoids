_ = require('underscore')
core = require('./core')
math = require('./math')
array = require('./array')
s = require('./string')
v = require('./validation')

_.extend(exports, core, array, s, v, math)
exports.inflector = require('./inflector')

_ = require('underscore')
_.extend(
    exports, 
    require('./validator'), 
    require('./logger')
)

core = require('./core')
math = require('./math')
array = require('./array')
s = require('./string')

_.extend(exports, core, array, s, math)
exports.inflector = require('./inflector')

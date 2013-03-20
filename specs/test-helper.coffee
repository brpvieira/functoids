util = require('util')
path = require('path')

sourceFolder = path.resolve(__dirname, '../src')
requireSrc = (pathToFile) -> require(path.resolve(sourceFolder, pathToFile))

module.exports = {
    requireSrc
}

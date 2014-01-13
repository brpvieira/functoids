should = require('should')

h = require('./test-helper')
F = h.requireSrc()

expected = null


describe('Logger', () ->

    it('should log some error', () ->
        F.logError("error message", {hello: 'world', data: 123})
        F.logError(new Error("error message"))
    )

    it('should log any variable', () ->
        F.logInfo('a')
        F.logInfo(1)
        F.logInfo(undefined)
        F.logInfo(null)
        F.logInfo(0.1)
        F.logInfo(new Object())
        F.logInfo(() ->)
    )

    it('should break circular refences in object context objects', () ->
        sample = {hello: 'world', data: 123}
        sample.id = sample
        F.logInfo("initialization", sample)
    )

    it('should break big objects', () ->
        sample = {a: {a: {a: {a: {a: {a: {a: 2}}}}}}}
        F.logInfo("initialization", sample)
    )

    it('should log all', () ->
        F.logAll('sample')
    )

)
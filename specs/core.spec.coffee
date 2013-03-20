h = require('./test-helper')

F = h.requireSrc()

describe('Core functions', ->
    it('Tells good from bad', () ->
        goodStuff = ['pink moon', '  whitespace  ', 10, 0, {}, new Date(), []]
        badStuff = [null, undefined, '   ']

        for g in goodStuff
            F.isGood(g).should.be.true
            F.isBad(g).should.be.false

        for b in badStuff
            F.isBad(b).should.be.true
            F.isGood(b).should.be.false
    )
)

h = require('./test-helper')

_ = h.requireSrc()

describe('Core functions', ->
    it('Tells good from bad', () ->
        goodStuff = ['pink moon', '  whitespace  ', 10, 0, {}, new Date(), []]
        badStuff = [null, undefined, '   ']

        for g in goodStuff
            _.isGood(g).should.be.true
            _.isBad(g).should.be.false

        for b in badStuff
            _.isBad(b).should.be.true
            _.isGood(b).should.be.false
    )
)

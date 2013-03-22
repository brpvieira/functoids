h = require('./test-helper')

assert = require('assert')

F = h.requireSrc()


funcs = ["demandObject", "demandArray", "demandNonEmptyArray", "demandString"]

wrap = (name, msg) ->
    (o, willThrow) ->
        f = () -> F[name](o)
        if willThrow
            f.should.throw(msg)
        else
            f().should.be.true

demandNotNil = wrap('demandNotNil', 'Argument must not be null or undefined')
demandObject = wrap('demandObject', 'Argument must be an object')
demandArray = wrap('demandArray', 'Argument must be an array')
demandNonEmptyArray = wrap('demandNonEmptyArray', 'Argument must be a non-empty array')
demandNonEmptyObject = wrap('demandNonEmptyObject', 'Argument must be a non-empty object')
demandNumber = wrap('demandNumber', 'Argument must be a number')
demandString = wrap('demandString', 'Argument must be a string')

describe 'Validation', () ->
    it 'demands not nil', () ->
        for arg in [null, undefined]
            demandNotNil(arg, true)

        for arg in [{}, 's', 10, {foo: 'bar'}, ["real clips", "real gats"]]
            demandNotNil(arg)

    it 'demands objects', () ->
        for arg in [null, 'bazinga', 6025]
            demandObject(arg, true)

        for arg in [{}, {foo: 'bar'}, ["real clips", "real gats"]]
            demandObject(arg)

    it 'demands non-empty objects', () ->
        for arg in [null, 'bazinga', 6025, {}]
            demandNonEmptyObject(arg, true)

        for arg in [{ foo: 'bar' }, ["it's hardcore real rap"]]
            demandNonEmptyObject(arg)

    it 'demands arrays', () ->
        for arg in ['fooz', { sensei: 'benbarazan' }, 34]
            demandArray(arg, true)

        for arg in [[], [1, 2], ['foo', 'bar', 55]]
            demandArray(arg)

    it 'demands non-empty arrays', () ->
        for arg in ['fooz', { sensei: 'benbarazan' }, 34, []]
            demandNonEmptyArray(arg, true)

        for arg in [[1, 2], ['foo', 'bar', 55]]
            demandNonEmptyArray(arg)

    it 'formats error messages with argument name', () ->
        msg = "Argument 'foobar' must be an object"
        fn = () -> F.demandObject(null, 'foobar')
        fn.should.throw(msg)

    it 'accepts custom argument error messages', () ->
        beauty = "in our height of hope, ever to be sober, " +
            "and in our depth of desolation, never to despair"

        msg = "Argument 'foobar' must #{beauty}"
        fn = () -> F.demandArray(null, 'foobar', beauty)
        fn.should.throw(msg)


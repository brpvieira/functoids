h = require('./test-helper')

assert = require('assert')

_ = h.requireSrc()

describe 'Array functions', () ->
    describe 'isOnlyElement', () ->
        it('Detects whether an object is the single element in an array', () ->
            _.isOnlyElement([10], 10).should.be.true
            _.isOnlyElement(null, 10).should.be.false
            _.isOnlyElement([10, 20], 10).should.be.false
            _.isOnlyElement(10, 10).should.be.false

            _.isOnlyElement('banzai', 'a').should.be.false
            _.isOnlyElement('b', 'b').should.be.false
        )

    describe 'firstOrSelf', () ->
        it("Returns an array's first element or the given non-array", () ->
            _.firstOrSelf('fooz').should.eql('fooz')
            _.firstOrSelf([10, 20, 30]).should.eql(10)
            _.firstOrSelf({}).should.eql({})
            _.firstOrSelf(10).should.eql(10)
        )

    describe 'secondOrNull', () ->
        it("Returns an array's second element or null", () ->
           _.secondOrNull([10, 20]).should.eql(20)
           assert.strictEqual(_.secondOrNull([10]), null)
           assert.strictEqual(_.secondOrNull('banzai'), null)
           assert.strictEqual(_.secondOrNull({ a: 10, b: 20 }), null)
        )

    describe 'lastIfFunction', () ->
        it 'Pops an array if the last element is a function', () ->
            f = () -> 'ayeee'
            _.lastIfFunction([10, 20, f]).should.eql(f)
            _.lastIfFunction([f]).should.eql(f)

            assert.equal(_.lastIfFunction([10, 20]), null)
            assert.equal(_.lastIfFunction([10, 20]), null)
            assert.equal(_.lastIfFunction([]), null)

    describe 'unwrapArgs', () ->
        noArgs = () ->
            a = _.unwrapArgs(arguments, true)
            assert.equal(a, null)

            a = _.unwrapArgs(arguments, false)
            assert.equal(a, null)

        singleArgument = (soleArg) ->
            a = _.unwrapArgs(arguments)
            a.should.eql(soleArg)

        skipsLast = (arg, skipLast) ->
            a = _.unwrapArgs(arguments, skipLast)
            if skipLast
                a.should.eql(arg)
            else
                a.should.eql([arg, skipLast])


        it 'Handles empty arguments', noArgs

        it 'Handles single arguments', () ->
            singleArgument(50)
            singleArgument('foobar')

        it 'Knows when to skip the last argument', () ->
            skipsLast(100, true)
            skipsLast(200, false)

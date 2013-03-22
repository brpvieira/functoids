h = require('./test-helper')

assert = require('assert')

F = h.requireSrc()

describe 'Array functions', () ->
    describe 'isOnlyElement', () ->
        it 'Detects whether an object is the single element in an array', () ->
            F.isOnlyElement([10], 10).should.be.true
            F.isOnlyElement(null, 10).should.be.false
            F.isOnlyElement([10, 20], 10).should.be.false
            F.isOnlyElement(10, 10).should.be.false

            F.isOnlyElement('banzai', 'a').should.be.false
            F.isOnlyElement('b', 'b').should.be.false


    describe 'firstOrSelf', () ->
        it "returns an array's first element or the given non-array", () ->
            F.firstOrSelf('fooz').should.eql('fooz')
            F.firstOrSelf([10, 20, 30]).should.eql(10)
            F.firstOrSelf({}).should.eql({})
            F.firstOrSelf(10).should.eql(10)


    describe 'secondOrNull', () ->
        it "returns an array's second element or null", () ->
           F.secondOrNull([10, 20]).should.eql(20)
           assert.strictEqual(F.secondOrNull([10]), null)
           assert.strictEqual(F.secondOrNull('banzai'), null)
           assert.strictEqual(F.secondOrNull({ a: 10, b: 20 }), null)


    describe 'unwrapSingle', () ->
        it "returns the element in a single-element array, or the passed argument otherwise", () ->
            F.unwrapSingle([10]).should.eql(10)
            F.unwrapSingle([10, 20]).should.eql([10, 20])
            F.unwrapSingle([10, 20]).should.eql([10, 20])
            F.unwrapSingle(50).should.eql(50)
            F.unwrapSingle({}).should.eql({})
            F.unwrapSingle({foo: 'bar'}).should.eql({foo: 'bar'})


    describe 'lastIfFunction', () ->
        it 'Pops an array if the last element is a function', () ->
            f = () -> 'ayeee'
            F.lastIfFunction([10, 20, f]).should.eql(f)
            F.lastIfFunction([f]).should.eql(f)

            assert.equal(F.lastIfFunction([10, 20]), null)
            assert.equal(F.lastIfFunction([10, 20]), null)
            assert.equal(F.lastIfFunction([]), null)

    describe 'unwrapArgs', () ->
        noArgs = () ->
            a = F.unwrapArgs(arguments, true)
            assert.equal(a, null)

            a = F.unwrapArgs(arguments, false)
            assert.equal(a, null)

        singleArgument = (soleArg) ->
            a = F.unwrapArgs(arguments)
            a.should.eql(soleArg)

        skipsLast = (arg, skipLast) ->
            a = F.unwrapArgs(arguments, skipLast)
            if skipLast
                a.should.eql(arg)
            else
                a.should.eql([arg, skipLast])


        it 'handles empty arguments', noArgs

        it 'handles single arguments', () ->
            singleArgument(50)
            singleArgument('foobar')

        it 'knows when to skip the last argument', () ->
            skipsLast(100, true)
            skipsLast(200, false)

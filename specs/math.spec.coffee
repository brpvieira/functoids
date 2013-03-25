h = require('./test-helper')

assert = require('assert')

F = h.requireSrc()

describe 'Math functions', () ->
    describe "Even round (banker's round or Gaussian rounding)", () ->
        it 'rounds the midpoint toward even numbers', () ->
            F.evenRound(2.555, 2).should.be.eql("2.56")
            F.evenRound(19.965, 2).should.be.eql("19.96")
            F.evenRound(19.995, 2).should.be.eql("20.00")
            F.evenRound(1.465, 2).should.be.eql("1.46")

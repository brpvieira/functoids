h = require('./test-helper')

_ = h.requireSrc()

# Please keep in mind that the preferred plural for 'octopus' and 'virus' in English are
# 'octopuses' and 'viruses', respectively. See:
# http://en.wikipedia.org/wiki/Octopus#Etymology_and_pluralization
# http://en.wikipedia.org/wiki/Virus#Etymology

describe('String functions', ->
    it('Can separate words into underscores, taking acronyms into account', ->
        _.underscore('OldMcDonald').should.eql('old_mc_donald')
        _.inflector.acronym('McDonald')
        _.underscore('OldMcDonald').should.eql('old_mcdonald')
        _.underscore('Old_McDonald').should.eql('old_mcdonald')
    )

    it('Converts to plural', () ->
        _.toPlural('man').should.eql('men')
        _.toPlural('octopus').should.eql('octopuses')
        _.toPlural('virus').should.eql('viruses')
        _.toPlural('criteria').should.eql('criteria')
        _.toPlural('xyzTable').should.eql('xyzTables')
    )

    it('Converts to singular', () ->
        _.toSingular('octopi').should.eql('octopus')
        _.toSingular('viri').should.eql('virus')
        _.toSingular('octopuses').should.eql('octopus')
    )

    it('Spacifies', () ->
        _.spacify('abcBamCam').should.eql('abc bam cam')
    )

    it('Converts to initial upper case', () ->
        _.toUpperInitial('foobar').should.eql('Foobar')
        _.toUpperInitial('Foobar').should.eql('Foobar')
        _.toUpperInitial('baba oreilly').should.eql('Baba oreilly')
    )

    it('Converts to initial lower case', () ->
        _.toLowerInitial('Foobar').should.eql('foobar')
        _.toLowerInitial('foobar').should.eql('foobar')
        _.toLowerInitial('Baba Oreilly').should.eql('baba Oreilly')
    )

    it('Implements from() to read from an index until the end of the string', () ->
        'zFoo'.slice(1).should.eql('Foo')
        'Dial a view'.slice(5).should.eql('a view')
        'Fonzo'.slice(10).should.eql('')
        ''.slice(1).should.eql('')
        't'.slice(1).should.eql('')
        't'.slice(0).should.eql('t')
    )

    it('Allows negative indices in from()', () ->
        'zFoo'.slice(-1).should.eql('o')
        'zFoo'.slice(-4).should.eql('zFoo')
        'zFoo'.slice(-40).should.eql('zFoo')
        ''.slice(-0).should.eql('')
        ''.slice(-1).should.eql('')
        't'.slice(-1).should.eql('t')
    )

    it 'Undelimits strings', ->
        _.undelimit("'foobar'").should.eql("foobar")
        _.undelimit("(foobar)").should.eql("foobar")
        _.undelimit("{foobar}").should.eql("foobar")
        _.undelimit("[foobar]").should.eql("foobar")
        _.undelimit('"foobar"').should.eql("foobar")

        _.undelimit('foobar"').should.eql('foobar"')
        _.undelimit('"foobar"b').should.eql('"foobar"b')
        _.undelimit('foobar').should.eql("foobar")

        _.undelimit('{foobar}', '""', '()').should.eql("{foobar}")
        _.undelimit('(foobar)', '{}', '()').should.eql("foobar")

    it('Makes strings into camel case', () ->
        _.toCamelCase('some_underscore_string').should.eql('SomeUnderscoreString')
        _.toCamelCase('some_underscore_string', false).should.eql('someUnderscoreString')
        _.toCamelCase('some_funky_id').should.eql('SomeFunkyId')
    )

    it('Takes acronyms into account when doing camel case', ->
        _.toCamelCase('TKO_by_anderson_silva').should.eql('TkoByAndersonSilva')
        _.toCamelCase('anderson_silva_by_TKO').should.eql('AndersonSilvaByTko')

        _.toCamelCase('TKO_by_anderson_silva', false).should.eql('tkoByAndersonSilva')
        _.toCamelCase('anderson_silva_by_TKO', false).should.eql('andersonSilvaByTko')

        _.inflector.acronym('TKO')
        _.underscore('anderson_silva_by_TKO').should.eql('anderson_silva_by_tko')
        _.toCamelCase('TKO_by_anderson_silva').should.eql('TKOByAndersonSilva')
        _.toCamelCase('anderson_silva_by_TKO').should.eql('AndersonSilvaByTKO')
        _.toCamelCase('TKO_by_anderson_silva', false).should.eql('tkoByAndersonSilva')
        _.toCamelCase('anderson_silva_by_TKO', false).should.eql('andersonSilvaByTKO')
    )
)

h = require('./test-helper')

F = h.requireSrc()

# Please keep in mind that the preferred plural for 'octopus' and 'virus' in English are
# 'octopuses' and 'viruses', respectively. See:
# http://en.wikipedia.org/wiki/Octopus#Etymology_and_pluralization
# http://en.wikipedia.org/wiki/Virus#Etymology

describe('String functions', ->
    it('Can separate words into underscores, taking acronyms into account', ->
        F.underscore('OldMcDonald').should.eql('old_mc_donald')
        F.inflector.acronym('McDonald')
        F.underscore('OldMcDonald').should.eql('old_mcdonald')
        F.underscore('Old_McDonald').should.eql('old_mcdonald')
    )

    it('Converts to plural', () ->
        F.toPlural('man').should.eql('men')
        F.toPlural('octopus').should.eql('octopuses')
        F.toPlural('virus').should.eql('viruses')
        F.toPlural('criteria').should.eql('criteria')
        F.toPlural('xyzTable').should.eql('xyzTables')
    )

    it('Converts to singular', () ->
        F.toSingular('octopi').should.eql('octopus')
        F.toSingular('viri').should.eql('virus')
        F.toSingular('octopuses').should.eql('octopus')
    )

    it('Spacifies', () ->
        F.spacify('abcBamCam').should.eql('abc bam cam')
    )

    it('Converts to initial upper case', () ->
        F.toUpperInitial('foobar').should.eql('Foobar')
        F.toUpperInitial('Foobar').should.eql('Foobar')
        F.toUpperInitial('baba oreilly').should.eql('Baba oreilly')
    )

    it('Converts to initial lower case', () ->
        F.toLowerInitial('Foobar').should.eql('foobar')
        F.toLowerInitial('foobar').should.eql('foobar')
        F.toLowerInitial('Baba Oreilly').should.eql('baba Oreilly')
    )

    it 'Undelimits strings', ->
        F.undelimit("'foobar'").should.eql("foobar")
        F.undelimit("(foobar)").should.eql("foobar")
        F.undelimit("{foobar}").should.eql("foobar")
        F.undelimit("[foobar]").should.eql("foobar")
        F.undelimit('"foobar"').should.eql("foobar")

        F.undelimit('foobar"').should.eql('foobar"')
        F.undelimit('"foobar"b').should.eql('"foobar"b')
        F.undelimit('foobar').should.eql("foobar")

        F.undelimit('{foobar}', '""', '()').should.eql("{foobar}")
        F.undelimit('(foobar)', '{}', '()').should.eql("foobar")

    it('Makes strings into camel case', () ->
        F.toCamelCase('some_underscore_string').should.eql('SomeUnderscoreString')
        F.toCamelCase('some_underscore_string', false).should.eql('someUnderscoreString')
        F.toCamelCase('some_funky_id').should.eql('SomeFunkyId')
    )

    it('Takes acronyms into account when doing camel case', ->
        F.toCamelCase('TKO_by_anderson_silva').should.eql('TkoByAndersonSilva')
        F.toCamelCase('anderson_silva_by_TKO').should.eql('AndersonSilvaByTko')

        F.toCamelCase('TKO_by_anderson_silva', false).should.eql('tkoByAndersonSilva')
        F.toCamelCase('anderson_silva_by_TKO', false).should.eql('andersonSilvaByTko')

        F.inflector.acronym('TKO')
        F.underscore('anderson_silva_by_TKO').should.eql('anderson_silva_by_tko')
        F.toCamelCase('TKO_by_anderson_silva').should.eql('TKOByAndersonSilva')
        F.toCamelCase('anderson_silva_by_TKO').should.eql('AndersonSilvaByTKO')
        F.toCamelCase('TKO_by_anderson_silva', false).should.eql('tkoByAndersonSilva')
        F.toCamelCase('anderson_silva_by_TKO', false).should.eql('andersonSilvaByTKO')
    )
)

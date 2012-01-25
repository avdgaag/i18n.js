describe 'i18n', ->
  it 'should exist', ->
    expect(i18n).not.toBeUndefined()
    expect(t).not.toBeUndefined()

  describe '#t', ->
    beforeEach ->
      i18n.translations = {}

    it 'should default to id when it is simple', ->
      expect(t 'foo').toEqual 'foo'

    it 'should default to the last id part if it is chained', ->
      expect(t 'foo.bar.baz').toEqual 'baz'

    it 'should use an explicit default value', ->
      expect(t 'foo', default: 'bar').toEqual 'bar'

    describe 'when there is a single key', ->
      beforeEach ->
        i18n.translations = en: foo: 'bar'

      it 'should find a top-level key', ->
        expect(t 'foo').toEqual 'bar'

      it 'should not use the default if a key exists', ->
        expect(t 'foo', default: 'baz').toEqual 'bar'

    describe 'when there are nested keys', ->
      beforeEach ->
        i18n.translations = en: foo: bar: 'baz'

      it 'should find nested keys', ->
        expect(t 'foo.bar').toEqual 'baz'

    describe 'interpolation', ->
      it 'should interpolate values into the translated string', ->
        i18n.translations = en: foo: 'hello, %{name}'
        expect(t 'foo', name: 'world').toEqual 'hello, world'

      it 'should interpolate the same value multiple times', ->
        i18n.translations = en: foo: 'hello, %{name}. Your name is %{name}'
        expect(t 'foo', name: 'world').toEqual 'hello, world. Your name is world'

      it 'should not interpolate the default value', ->
        i18n.translations = en: foo: 'hello, %{default}'
        expect(t 'foo', default: 'bar').toEqual 'hello, %{default}'

      it 'should interpolate the default value with vars', ->
        expect(t 'foo', default: 'hello, %{name}', name: 'world').toEqual 'hello, world'

      it 'should not remove placeholders for non-existant keys', ->
        i18n.translations = en: foo: 'hello, %{name}'
        expect(t 'foo').toEqual 'hello, %{name}'

    describe 'with multiple languages', ->
      beforeEach ->
        i18n.translations =
          en:
            foo: 'bar'
          nl:
            foo: 'baz'

      it 'should by default scope to top-level en key', ->
        expect(t 'foo').toEqual 'bar'

      it 'should switch to another language based on the HTML lang attribute', ->
        i18n.locale = 'nl'
        expect(t 'foo').toEqual 'baz'

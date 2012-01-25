# Simple i18n for client-side javascript

Provide a `t` method that works similarly to `t` found in Rails, so you can
write your javascript views using simple keys that get translated on the
client side to the current locale.

## Setting the locale

The current locale can be directly set on the global `i18n` object as a
two-letter country code:

```coffee
window.i18n.locale = 'nl'
```

By default, a `i18n` is created for you with the locale set to the value of
the document's root HTML element's `lang` attribute. So in the following
example the locale will be `nl`:

```html
<!doctype html>
<html lang="nl">
...
</html>
```

When no translation is given, 'en' will be used as the default.

## Defining translations

The full set of translations is a simple Javascript object with keys and
values.  You define them on `translations`:

```coffee
window.i18n.translations =
  en:
    welcome: 'Welcome'
  nl:
    welcome: 'Welkom'
```

You can nest multiple objects for namespacing purposes:

```coffee
window.i18n.translations =
  nl:
    dialogs:
      cancel: 'Annuleren'
```

## Translating a key

The `I18n` provides the `translate` function, which is aliased by default as
`t` on the global object. Usage is simple:

``` coffee
t('foo') # => 'bar'
```

### Nested key lookup

When you namespace translation keys, you can use a string with dot notation
to locate it, just like in Rails:

```coffee
window.i18n.translations = 
  nl:
    dialogs:
      cancel: 'Annuleren'
t 'dialogs.cancel' # => 'Annuleren'
```

Note that you do not have to provide the top-level key that maps to the
current locale.

### String interpolation

Simple string interpolation is supported for translatable strings:

```coffee
window.i18n.translations =
  nl:
    greeting: 'Hello, %{name}!'
t 'greeting', name: 'world' # => 'Hello, world!'
```

The second argument is an object whose keys will be used to fill in the
specially formatted placeholders in the translated string.

Note that placeholders for which no value is defined are left alone and will
show up on the site, which is not pretty.

### Default values

There is a special option to set on the second argument to `t` called
`default`, which will be used as the translated string when there is no value
explicitly set for the given key.

```coffee
t 'nonexistant_key', default: 'foo' # => 'foo'
```

When a key does not exist, and no default value is explicitly provided, the
last part of they key will be used as default:

```coffee
t 'foo.bar.baz' # => 'baz'
```

## Usage

Just include this script on any page. Use it in a Rails project with the
asset pipeline by adding the files to your `vendor/assets` or `lib/assets`
directory and requiring it in your manifest file:

```js
// in app/assets/javacsripts/application.js
/*
 * require 'i18n'
 */
```

Then, you might want to define a separate file in your `app/assets` directory
containing your translations. (Automatically) including your Rails app's
translations in this file is left as an excercise for the reader...

```coffee
# app/assets/javascripts/translations.coffee
@i18n.translations:
  en:
    foo: 'bar'
  nl:
    foo: 'baz'
```

The repository also contains a pre-compiled javascript version which you can
include on any page:

```html
<script src="i18n.js"></script>
<script>
window.i18n.translations = {
  en: {
    foo: 'bar'
  },
  nl: {
    foo: 'baz'
  }
};
</script>
```

## Dependencies

This script has no external dependencies.

## Contributions

Pull requests and bug reports are much appreciated. If you want to contribute,
make sure to edit the `lib/i18n.coffee` file, not the `lib/i18n.js` file.

## Credits

**Author** Arjan van der Gaag  
**Email** <arjan@arjanvandergaag.nl>  
**URL** <http://arjanvandergaag.nl>  
**Date**   2011-11-23

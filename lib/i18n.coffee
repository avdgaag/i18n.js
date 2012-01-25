# ## Simple i18n for client-side javascript
#
# Provide a `t` method that works similarly to `t` found in Rails, so you can
# write your javascript views using simple keys that get translated on the
# client side to the current locale.
#
# ### Setting the locale
#
# The current locale can be directly set on the global `i18n` object as a
# two-letter country code:
#
#     window.i18n.locale = 'nl'
#
# By default, a `i18n` is created for you with the locale set to the value of
# the document's root HTML element's `lang` attribute. So in the following
# example the locale will be `nl`:
#
#     <!doctype html>
#     <html lang="nl">
#     ...
#     </html>
#
# When no translation is given, 'en' will be used as the default.
#
# ### Defining translations
#
# The full set of translations is a simple Javascript object with keys and
# values.  You define them on `translations`:
#
#     window.i18n.translations =
#       en:
#         welcome: 'Welcome'
#       nl:
#         welcome: 'Welkom'
#
# You can nest multiple objects for namespacing purposes:
#
#     window.i18n.translations =
#       nl:
#         dialogs:
#           cancel: 'Annuleren'
#
# ### Translating a key
#
# The `I18n` provides the `translate` function, which is aliased by default as
# `t` on the global object. Usage is simple:
#
#     t('foo') # => 'bar'
#
# #### Nested key lookup
#
# When you namespace translation keys, you can use a string with dot notation
# to locate it, just like in Rails:
#
#     window.i18n.translations = 
#       nl:
#         dialogs:
#           cancel: 'Annuleren'
#     t 'dialogs.cancel' # => 'Annuleren'
#
# Note that you do not have to provide the top-level key that maps to the
# current locale.
#
# #### String interpolation
#
# Simple string interpolation is supported for translatable strings:
#
#     window.i18n.translations =
#       nl:
#         greeting: 'Hello, %{name}!'
#     t 'greeting', name: 'world' # => 'Hello, world!'
#
# The second argument is an object whose keys will be used to fill in the
# specially formatted placeholders in the translated string.
#
# Note that placeholders for which no value is defined are left alone and will
# show up on the site, which is not pretty.
#
# #### Default values
#
# There is a special option to set on the second argument to `t` called
# `default`, which will be used as the translated string when there is no value
# explicitly set for the given key.
#
#     t 'nonexistant_key', default: 'foo' # => 'foo'
#
# When a key does not exist, and no default value is explicitly provided, the
# last part of they key will be used as default:
#
#     t 'foo.bar.baz' # => 'baz'
# 
# ### Usage
#
# Just include this script on any page. Use it in a Rails project with the
# asset pipeline by adding the files to your `vendor/assets` or `lib/assets`
# directory and requiring it in your manifest file:
#
#     # app/assets/javacsripts/application.js
#     /*
#      * require 'i18n'
#      */
# 
# Then, you might want to define a separate file in your `app/assets` directory
# containing your translations. (Automatically) including your Rails app's
# translations in this file is left as an excercise for the reader...
#
#     # app/assets/javascripts/translations.coffee
#     @i18n.translations:
#       en:
#         foo: 'bar'
#       nl:
#         foo: 'baz'
# 
# The repository also contains a pre-compiled javascript version which you can
# include on any page:
#
#     <script src="i18n.js"></script>
#     <script>
#     window.i18n.translations = {
#       en: {
#         foo: 'bar'
#       },
#       nl: {
#         foo: 'baz'
#       }
#     };
#     </script>
#
# ### Dependencies
#
# This script has no external dependencies.
#
# ### Credits
#
# **Author** Arjan van der Gaag <br>
# **Email** <arjan@arjanvandergaag.nl><br>
# **URL** <http://arjanvandergaag.nl><br>
# **Date** 2011-11-23<br>
# **Source & issues** <http://github.com/avdgaag/i18n.js>

# ---

# ## The I18n object

# The `I18n` class encapsulates the functionality for looking up keys and
# handling defaults and interpolation.
# 
# An instance of this class is automatically created, but there's nothing
# stopping you from creating another manually.
class I18n

  # Set up a new translations object for a given language, defaulting to `en`.
  # Recommended usage is creating a new object with the value of the `lang`
  # attribute of the page's `html` element.
  #
  # If you want to manually set the locale -- and not use the auto-selected value
  # based on the `html` element's `lang` attribute -- you could also just manually
  # assign it:
  #
  #     window.i18n.locale = 'de'
  #
  constructor: (@locale = 'en') ->
    @translations = {}

  # Fetch a translation for a JSON path from the `translations` attribute,
  # which should be set externally.
  fetch: (path) ->
    parts = path.split '.'
    key   = parts.pop()
    scope = @translations[@locale]
    scope = scope?[part] for part in parts
    scope?[key]

  # Interpolate values from a `dict` object into the translation string `str`.
  # This ignores the `default` key from `dict` so all the options to to
  # the `translate` function can be passed straight into this function.
  format: (str, dict) ->
    for key, value of dict when key isnt 'default'
      str = str.replace new RegExp("%{#{key}}", 'g'), value
    str

  # Get the translated value for a given path, returning a string with the values
  # from `options` interpolated in it. When no translation is available, use the
  # `default` key from options as a fallback. If no fallback is provided,
  # simply use the last part of the path string.
  translate: (path, options = {}) =>
    @format(@fetch(path) || options.default || path.split('.').pop(), options)

# ---

# ## Auto-setup

# Automatically set up a single new `I18n` object based on the language of the
# current document's `html` element's `lang` attribute.
@i18n = new I18n document.getElementsByTagName('html')[0].getAttribute 'lang'

# Alias the `translate` function to `t`
@t = @i18n.translate

(function() {
  var I18n,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  I18n = (function() {

    function I18n(locale) {
      this.locale = locale != null ? locale : 'en';
      this.translate = __bind(this.translate, this);
      this.translations = {};
    }

    I18n.prototype.fetch = function(path) {
      var key, part, parts, scope, _i, _len;
      parts = path.split('.');
      key = parts.pop();
      scope = this.translations[this.locale];
      for (_i = 0, _len = parts.length; _i < _len; _i++) {
        part = parts[_i];
        scope = scope != null ? scope[part] : void 0;
      }
      return scope != null ? scope[key] : void 0;
    };

    I18n.prototype.format = function(str, dict) {
      var key, value;
      for (key in dict) {
        value = dict[key];
        if (key !== 'default') {
          str = str.replace(new RegExp("%{" + key + "}", 'g'), value);
        }
      }
      return str;
    };

    I18n.prototype.translate = function(path, options) {
      if (options == null) options = {};
      return this.format(this.fetch(path) || options["default"] || path.split('.').pop(), options);
    };

    return I18n;

  })();

  this.i18n = new I18n(document.getElementsByTagName('html')[0].getAttribute('lang'));

  this.t = this.i18n.translate;

}).call(this);

"use strict"
/*

Much of this code and all of the good ideas were taken from the Sugar JS library
Copyright (c) Andrew Plummer, http://sugarjs.com/

Modifications copyright(c) Gustavo Duarte


Please keep in mind that the preferred plural for 'octopus' and 'virus' in English are
'octopuses' and 'viruses', respectively. See:
http:en.wikipedia.org/wiki/Octopus#Etymology_and_pluralization
http:en.wikipedia.org/wiki/Virus#Etymology
 
*/

var _ = require('underscore'),
    F = require('./');

function multiArgs(args, fn) {
    var result = [], i;
    for(i = 0; i < args.length; i++) {
        result.push(args[i]);
        if(fn) fn.call(args, args[i], i);
    }
    return result;
};

function assign(s) {
    var assign = {};
    multiArgs(_.rest(arguments), function(a, i) {
        if(_.isObject(a)) {
            _.extend(assign, a);
        } else {
            assign[i + 1] = a;
        }
    });

    return s.replace(/\{([^{]+?)\}/g, function(m, key) {
        return assign.hasOwnProperty(key) ? assign[key] : m;
    });
};

function iterateOverObject(obj, fn) {
    var key;
    for(key in obj) {
        if(!obj.hasOwnProperty(key)) continue;
        if(fn.call(obj, key, obj[key], obj) === false) break;
    }
}

  var plurals      = [],
      singulars    = [],
      uncountables = [],
      humans       = [],
      acronyms     = {},
      downcased,
      inflector;

  function removeFromArray(arr, find) {
    var index = arr.indexOf(find);
    if(index > -1) {
      arr.splice(index, 1);
    }
  }

  function removeFromUncountablesAndAddTo(arr, rule, replacement) {
    if(_.isString(rule)) {
      removeFromArray(uncountables, rule);
    }
    removeFromArray(uncountables, replacement);
    arr.unshift({ rule: rule, replacement: replacement })
  }

  function paramMatchesType(param, type) {
    return param == type || param == 'all' || !param;
  }

  function isUncountable(word) {
    return uncountables.some(function(uncountable) {
      return new RegExp('\\b' + uncountable + '$', 'i').test(word);
    });
  }

  function inflect(word, pluralize) {
    word = _.isString(word) ? word.toString() : '';
    if(!F.isGoodString(word) || isUncountable(word)) {
      return word;
    } else {
      return runReplacements(word, pluralize ? plurals : singulars);
    }
  }

  function runReplacements(word, table) {
    iterateOverObject(table, function(i, inflection) {
      if(word.match(inflection.rule)) {
        word = word.replace(inflection.rule, inflection.replacement);
        return false;
      }
    });
    return word;
  }

  function capitalize(word) {
    return word.replace(/^\W*[a-z]/, function(w){
      return w.toUpperCase();
    });
  }

  var inflector = {

    /*
     * Specifies a new acronym. An acronym must be specified as it will appear in a camelized string.  An underscore
     * string that contains the acronym will retain the acronym when passed to %camelize%, %humanize%, or %titleize%.
     * A camelized string that contains the acronym will maintain the acronym when titleized or humanized, and will
     * convert the acronym into a non-delimited single lowercase word when passed to String#underscore.
     *
     * Examples:
     *   _.inflector.acronym('HTML')
     *   'html'.titleize()     -> 'HTML'
     *   'html'.camelize()     -> 'HTML'
     *   'MyHTML'.underscore() -> 'my_html'
     *
     * The acronym, however, must occur as a delimited unit and not be part of another word for conversions to recognize it:
     *
     *   _.inflector.acronym('HTTP')
     *   'my_http_delimited'.camelize() -> 'MyHTTPDelimited'
     *   'https'.camelize()             -> 'Https', not 'HTTPs'
     *   'HTTPS'.underscore()           -> 'http_s', not 'https'
     *
     *   _.inflector.acronym('HTTPS')
     *   'https'.camelize()   -> 'HTTPS'
     *   'HTTPS'.underscore() -> 'https'
     *
     * Note: Acronyms that are passed to %pluralize% will no longer be recognized, since the acronym will not occur as
     * a delimited unit in the pluralized result. To work around this, you must specify the pluralized form as an
     * acronym as well:
     *
     *    _.inflector.acronym('API')
     *    'api'.pluralize().camelize() -> 'Apis'
     *
     *    _.inflector.acronym('APIs')
     *    'api'.pluralize().camelize() -> 'APIs'
     *
     * %acronym% may be used to specify any word that contains an acronym or otherwise needs to maintain a non-standard
     * capitalization. The only restriction is that the word must begin with a capital letter.
     *
     * Examples:
     *   _.inflector.acronym('RESTful')
     *   'RESTful'.underscore()           -> 'restful'
     *   'RESTfulController'.underscore() -> 'restful_controller'
     *   'RESTfulController'.titleize()   -> 'RESTful Controller'
     *   'restful'.camelize()             -> 'RESTful'
     *   'restful_controller'.camelize()  -> 'RESTfulController'
     *
     *   _.inflector.acronym('McDonald')
     *   'McDonald'.underscore() -> 'mcdonald'
     *   'mcdonald'.camelize()   -> 'McDonald'
     */
    'acronym': function(word) {
      acronyms[word.toLowerCase()] = word;
      var all = _(acronyms).keys().map(function(key) {
        return acronyms[key];
      });
      // MUST: make pull request to Sugar's maintainer
      inflector.acronymRegExp = new RegExp('_?(' + all.join('|') + ')', 'g');
    },

    /*
     * Specifies a new pluralization rule and its replacement. The rule can either be a string or a regular expression.
     * The replacement should always be a string that may include references to the matched data from the rule.
     */
    'plural': function(rule, replacement) {
      removeFromUncountablesAndAddTo(plurals, rule, replacement);
    },

    /*
     * Specifies a new singularization rule and its replacement. The rule can either be a string or a regular expression.
     * The replacement should always be a string that may include references to the matched data from the rule.
     */
    'singular': function(rule, replacement) {
      removeFromUncountablesAndAddTo(singulars, rule, replacement);
    },

    /*
     * Specifies a new irregular that applies to both pluralization and singularization at the same time. This can only be used
     * for strings, not regular expressions. You simply pass the irregular in singular and plural form.
     *
     * Examples:
     *   _.inflector.irregular('alumnus', 'alumni')
     *   _.inflector.irregular('person', 'people')
     */
    'irregular': function(singular, plural) {
      var singularFirst      = singular.charAt(0),
          singularRest       = singular.substr(1),
          pluralFirst        = plural.charAt(0),
          pluralRest         = plural.substr(1),
          pluralFirstUpper   = pluralFirst.toUpperCase(),
          pluralFirstLower   = pluralFirst.toLowerCase(),
          singularFirstUpper = singularFirst.toUpperCase(),
          singularFirstLower = singularFirst.toLowerCase();

      removeFromArray(uncountables, singular);
      removeFromArray(uncountables, plural);

      if(singularFirstUpper == pluralFirstUpper) {
        inflector.plural(new RegExp(assign('({1}){2}$', singularFirst, singularRest), 'i'), '$1' + pluralRest);
        inflector.plural(new RegExp(assign('({1}){2}$', pluralFirst, pluralRest), 'i'), '$1' + pluralRest);
        inflector.singular(new RegExp(assign('({1}){2}$', pluralFirst, pluralRest), 'i'), '$1' + singularRest);
      } else {
        inflector.plural(new RegExp(assign('{1}{2}$', singularFirstUpper, singularRest)), pluralFirstUpper + pluralRest);
        inflector.plural(new RegExp(assign('{1}{2}$', singularFirstLower, singularRest)), pluralFirstLower + pluralRest);
        inflector.plural(new RegExp(assign('{1}{2}$', pluralFirstUpper, pluralRest)), pluralFirstUpper + pluralRest);
        inflector.plural(new RegExp(assign('{1}{2}$', pluralFirstLower, pluralRest)), pluralFirstLower + pluralRest);
        inflector.singular(new RegExp(assign('{1}{2}$', pluralFirstUpper, pluralRest)), singularFirstUpper + singularRest);
        inflector.singular(new RegExp(assign('{1}{2}$', pluralFirstLower, pluralRest)), singularFirstLower + singularRest);
      }
    },

    /*
     * Add uncountable words that shouldn't be attempted inflected.
     *
     * Examples:
     *   _.inflector.uncountable('money')
     *   _.inflector.uncountable('money', 'information')
     *   _.inflector.uncountable(['money', 'information', 'rice'])
     */
    'uncountable': function(first) {
      var add = _.isArray(first) ? first : multiArgs(arguments);
      uncountables = uncountables.concat(add);
    },

    /*
     * Specifies a humanized form of a string by a regular expression rule or by a string mapping.
     * When using a regular expression based replacement, the normal humanize formatting is called after the replacement.
     * When a string is used, the human form should be specified as desired (example: 'The name', not 'the_name')
     *
     * Examples:
     *   _.inflector.human(/_cnt$/i, '_count')
     *   _.inflector.human('legacy_col_person_name', 'Name')
     */
    'human': function(rule, replacement) {
      humans.unshift({ rule: rule, replacement: replacement })
    },


    /*
     * Clears the loaded inflections within a given scope (default is 'all').
     * Options are: 'all', 'plurals', 'singulars', 'uncountables', 'humans'.
     *
     * Examples:
     *   _.inflector.clear('all')
     *   _.inflector.clear('plurals')
     */
    'clear': function(type) {
      if(paramMatchesType(type, 'singulars'))    singulars    = [];
      if(paramMatchesType(type, 'plurals'))      plurals      = [];
      if(paramMatchesType(type, 'uncountables')) uncountables = [];
      if(paramMatchesType(type, 'humans'))       humans       = [];
      if(paramMatchesType(type, 'acronyms'))     acronyms     = {};
    }

  };

  downcased = [
    'and', 'or', 'nor', 'a', 'an', 'the', 'so', 'but', 'to', 'of', 'at',
    'by', 'from', 'into', 'on', 'onto', 'off', 'out', 'in', 'over',
    'with', 'for'
  ];

  inflector.plural(/$/, 's');
  inflector.plural(/s$/gi, 's');
  inflector.plural(/(ax|test)is$/gi, '$1es');
  inflector.plural(/(fung|foc|radi|alumn)(i|us)$/gi, '$1i');
  inflector.plural(/(census|alias|status|octopus|virus)$/gi, '$1es');
  inflector.plural(/(bu)s$/gi, '$1ses');
  inflector.plural(/(buffal|tomat)o$/gi, '$1oes');
  inflector.plural(/([ti])um$/gi, '$1a');
  inflector.plural(/([ti])a$/gi, '$1a');
  inflector.plural(/sis$/gi, 'ses');
  inflector.plural(/f+e?$/gi, 'ves');
  inflector.plural(/(cuff|roof)$/gi, '$1s');
  inflector.plural(/([ht]ive)$/gi, '$1s');
  inflector.plural(/([^aeiouy]o)$/gi, '$1es');
  inflector.plural(/([^aeiouy]|qu)y$/gi, '$1ies');
  inflector.plural(/(x|ch|ss|sh)$/gi, '$1es');
  inflector.plural(/(matr|vert|ind)(?:ix|ex)$/gi, '$1ices');
  inflector.plural(/([ml])ouse$/gi, '$1ice');
  inflector.plural(/([ml])ice$/gi, '$1ice');
  inflector.plural(/^(ox)$/gi, '$1en');
  inflector.plural(/^(oxen)$/gi, '$1');
  inflector.plural(/(quiz)$/gi, '$1zes');
  inflector.plural(/(phot|cant|hom|zer|pian|portic|pr|quart|kimon)o$/gi, '$1os');
  inflector.plural(/(craft)$/gi, '$1');
  inflector.plural(/([ft])[eo]{2}(th?)$/gi, '$1ee$2');

  inflector.singular(/s$/gi, '');
  inflector.singular(/([pst][aiu]s)$/gi, '$1');
  inflector.singular(/([aeiouy])ss$/gi, '$1ss');
  inflector.singular(/(n)ews$/gi, '$1ews');
  inflector.singular(/([ti])a$/gi, '$1um');
  inflector.singular(/((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$/gi, '$1$2sis');
  inflector.singular(/(^analy)ses$/gi, '$1sis');
  inflector.singular(/(i)(f|ves)$/i, '$1fe');
  inflector.singular(/([aeolr]f?)(f|ves)$/i, '$1f');
  inflector.singular(/([ht]ive)s$/gi, '$1');
  inflector.singular(/([^aeiouy]|qu)ies$/gi, '$1y');
  inflector.singular(/(s)eries$/gi, '$1eries');
  inflector.singular(/(m)ovies$/gi, '$1ovie');
  inflector.singular(/(x|ch|ss|sh)es$/gi, '$1');
  inflector.singular(/([ml])(ous|ic)e$/gi, '$1ouse');
  inflector.singular(/(bus)(es)?$/gi, '$1');
  inflector.singular(/(o)es$/gi, '$1');
  inflector.singular(/(shoe)s?$/gi, '$1');
  inflector.singular(/(cris|ax|test)[ie]s$/gi, '$1is');
  inflector.singular(/(octop|vir|fung|foc|radi|alumn)(i|us)$/gi, '$1us');
  inflector.singular(/(census|alias|status|octopus|virus)(es)?$/gi, '$1');
  inflector.singular(/^(ox)(en)?/gi, '$1');
  inflector.singular(/(vert|ind)(ex|ices)$/gi, '$1ex');
  inflector.singular(/(matr)(ix|ices)$/gi, '$1ix');
  inflector.singular(/(quiz)(zes)?$/gi, '$1');
  inflector.singular(/(database)s?$/gi, '$1');
  inflector.singular(/ee(th?)$/gi, 'oo$1');

  inflector.irregular('person', 'people');
  inflector.irregular('man', 'men');
  inflector.irregular('child', 'children');
  inflector.irregular('sex', 'sexes');
  inflector.irregular('move', 'moves');
  inflector.irregular('save', 'saves');
  inflector.irregular('save', 'saves');
  inflector.irregular('cow', 'kine');
  inflector.irregular('goose', 'geese');
  inflector.irregular('zombie', 'zombies');

  inflector.uncountable('equipment,information,rice,money,species,series,fish,sheep,jeans'.split(','));


inflector.inflect = inflect
inflector.acronyms = acronyms

module.exports = inflector 

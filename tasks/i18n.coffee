path = require 'path'

module.exports = (grunt) ->
  grunt.registerMultiTask 'i18n', 'Localize Grunt templates', ->
    options = @options
      locales: []
      output: '.'
      base: ''

    grunt.verbose.writeflags options, 'Options'

    for filepath in @filesSrc
      localePaths = grunt.file.expand options.locales
      for localePath in localePaths
        translateTemplates filepath, localePath, options

  translateTemplates = (templatePath, localePath, options) ->
    template = grunt.file.read templatePath
    local = grunt.file.readJSON localePath
    localizedTemplate = grunt.template.process template, {data: local}
    outputFolder = path.basename localePath, path.extname localePath
    output = generateOutputPath outputFolder, templatePath, options
    grunt.file.write output, localizedTemplate

  generateOutputPath = (localeFolder, filepath, options) ->
    filepath = filepath.slice options.base.length if grunt.util._.startsWith filepath, options.base
    filepath = grunt.util._.trim filepath, path.sep
    [options.output, localeFolder, filepath].join path.sep

  return @
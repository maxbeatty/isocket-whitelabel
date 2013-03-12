# Generated on 2013-03-11 using generator-webapp 0.1.5
'use strict';
lrSnippet = require('grunt-contrib-livereload/lib/utils').livereloadSnippet;

mountFolder = (connect, dir) ->
  connect.static require('path').resolve(dir)

module.exports = (grunt) ->
  # load all grunt tasks
  require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks

  # configurable paths
  yeomanConfig =
      app: 'app'
      dist: 'dist'

  grunt.initConfig
    yeoman: yeomanConfig
    watch:
      coffee:
        files: ['<%= yeoman.app %>/scripts/{,*/}*.coffee']
        tasks: ['coffee:dist']

      coffeeTest:
        files: ['test/spec/{,*/}*.coffee']
        tasks: ['coffee:test']

      compass:
        files: ['<%= yeoman.app %>/styles/{,*/}*.{scss,sass}']
        tasks: ['compass']

      livereload:
        files: [
          '<%= yeoman.app %>/*.html',
          '{.tmp,<%= yeoman.app %>}/styles/{,*/}*.css',
          '{.tmp,<%= yeoman.app %>}/scripts/{,*/}*.js',
          '<%= yeoman.app %>/images/{,*/}*.{png,jpg,jpeg,webp}'
        ]
        tasks: ['livereload']

    connect:
      options:
        port: 9000
        # change this to '0.0.0.0' to access the server from outside
        hostname: 'localhost'

      livereload:
        options:
          middleware: (connect) ->
            [
              lrSnippet,
              mountFolder(connect, '.tmp'),
              mountFolder(connect, 'app')
            ]
      test:
        options:
          middleware: (connect) ->
            [
              mountFolder(connect, '.tmp'),
              mountFolder(connect, 'test')
            ]
      dist:
        options:
          middleware: (connect) ->
            [
              mountFolder(connect, 'dist')
            ]
    open:
      server:
        path: 'http://localhost:<%= connect.options.port %>'
    clean:
      dist: ['.tmp', '<%= yeoman.dist %>/*']
      server: '.tmp'
    jshint:
      options:
        jshintrc: '.jshintrc'
      all: [
        'Gruntfile.js',
        '<%= yeoman.app %>/scripts/{,*/}*.js',
        '!<%= yeoman.app %>/scripts/vendor/*',
        'test/spec/{,*/}*.js'
      ]
    mocha:
      all:
        options:
          run: true
          urls: ['http://localhost:<%= connect.options.port %>/index.html']
    coffee:
      dist:
        files: [
          # rather than compiling multiple files here you should
          # require them into your main .coffee file
          expand: true,
          cwd: '<%= yeoman.app %>/scripts',
          src: '*.coffee',
          dest: '.tmp/scripts',
          ext: '.js'
        ]
      test:
        files: [
          expand: true,
          cwd: '.tmp/spec',
          src: '*.coffee',
          dest: 'test/spec'
        ]
    compass:
      options:
        sassDir: '<%= yeoman.app %>/styles'
        cssDir: '.tmp/styles'
        imagesDir: '<%= yeoman.app %>/images'
        javascriptsDir: '<%= yeoman.app %>/scripts'
        fontsDir: '<%= yeoman.app %>/styles/fonts'
        importPath: 'app/components'
        relativeAssets: true
      dist: {}
      server:
        options:
          debugInfo: true
    ###
    # not used since Uglify task does concat,
    # but still available if needed
    concat:
        dist: {}
    ###
    requirejs:
      dist:
        # Options: https://github.com/jrburke/r.js/blob/master/build/example.build.js
        options:
          # `name` and `out` is set by grunt-usemin
          baseUrl: 'app/scripts'
          optimize: 'none'
          # TODO: Figure out how to make sourcemaps work with grunt-usemin
          # https://github.com/yeoman/grunt-usemin/issues/30
          #generateSourceMaps: true,
          # required to support SourceMaps
          # http://requirejs.org/docs/errors.html#sourcemapcomments
          preserveLicenseComments: false
          useStrict: true
          wrap: true
          # uglify2: {} // https://github.com/mishoo/UglifyJS2
    useminPrepare:
        html: '<%= yeoman.app %>/index.html'
        options:
          dest: '<%= yeoman.dist %>'
    usemin:
        html: ['<%= yeoman.dist %>/{,*/}*.html']
        css: ['<%= yeoman.dist %>/styles/{,*/}*.css']
        options:
          dirs: ['<%= yeoman.dist %>']
    imagemin:
      dist:
        files: [
          expand: true
          cwd: '<%= yeoman.app %>/images'
          src: '{,*/}*.{png,jpg,jpeg}'
          dest: '<%= yeoman.dist %>/images'
        ]
    cssmin:
      dist:
        files:
          '<%= yeoman.dist %>/styles/main.css': [
            '.tmp/styles/{,*/}*.css',
            '<%= yeoman.app %>/styles/{,*/}*.css'
          ]
    htmlmin:
      dist:
        files: [
          expand: true
          cwd: '<%= yeoman.app %>'
          src: '*.html'
          dest: '<%= yeoman.dist %>'
        ]
    copy:
      dist:
        files: [
          expand: true
          dot: true
          cwd: '<%= yeoman.app %>'
          dest: '<%= yeoman.dist %>'
          src: [
            '*.{ico,txt}'
            '.htaccess'
          ]
        ]
    bower:
      all:
        rjsConfig: '<%= yeoman.app %>/scripts/main.js'

  grunt.renameTask 'regarde', 'watch'

  grunt.registerTask 'server', (target) ->
      if target is 'dist'
        return grunt.task.run ['build', 'open', 'connect:dist:keepalive']

      grunt.task.run [
        'clean:server',
        'coffee:dist',
        'compass:server',
        'livereload-start',
        'connect:livereload',
        'open',
        'watch'
      ]

  grunt.registerTask 'test', [
    'clean:server',
    'coffee',
    'compass',
    'connect:test',
    'mocha'
  ]

  grunt.registerTask 'build', [
    'clean:dist',
    'coffee',
    'compass:dist',
    'useminPrepare',
    'requirejs',
    'imagemin',
    'htmlmin',
    'concat',
    'cssmin',
    'uglify',
    'copy',
    'usemin'
  ]

  grunt.registerTask 'default', [
      'jshint',
      'test',
      'build'
  ]

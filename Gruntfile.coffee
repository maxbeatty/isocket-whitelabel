lrSnippet = require('grunt-contrib-livereload/lib/utils').livereloadSnippet

mountFolder = (connect, dir) ->
  connect.static require('path').resolve(dir)

module.exports = (grunt) ->
  # load all grunt tasks
  require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks

  # configurable paths
  yeomanConfig =
    app: 'app'
    dist: 'dist'

  isocketConfig =
    api:
      version: 'v0'
      host:
        dev: 'http://f.dev/wl'
        prod: 'http://f.isocket.com/wl'
    cdn:
      dev: 'whitelabel.dev'
      prod: 'whitelabel.buyads.com'

  grunt.initConfig
    yeoman: yeomanConfig
    isocket: isocketConfig

    regarde:
      coffee:
        files: ['<%= yeoman.app %>/scripts/{,*/}*.coffee']
        tasks: ['coffeelint', 'coffee:dist']

      coffeeTest:
        files: ['test/spec/{,*/}*.coffee']
        tasks: ['coffeelint', 'coffee:test']

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
        port: 7777
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
      options:
        bare: true
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
    coffeelint:
      dist: [
        'Gruntfile.coffee',
        '<%= yeoman.app %>/scripts/*.coffee'
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

    # Ref: https://github.com/jrburke/r.js/blob/master/build/example.build.js
    requirejs:
      dist:
        options:
          baseUrl: '.tmp/scripts'
          paths:
            requireLib: '../../components/requirejs/require'
          include: 'requireLib'
          optimize: 'uglify2'
          generateSourceMaps: true
          preserveLicenseComments: false
          useStrict: true
          wrap: true
          name: 'front'
          out: '<%= yeoman.dist %>/<%= isocket.api.version %>/front.js'
          mainConfigFile: '.tmp/scripts/front.js'
    uglify:
      options:
        mangle:
          except: ['jQuery']
        compress: true
      dist:
        files:
          '<%= yeoman.dist %>/<%= isocket.api.version %>/store.js': [
            '<%= yeoman.dist %>/<%= isocket.api.version %>/store.js'
          ]
    useminPrepare:
      html: '<%= yeoman.app %>/_build.html'
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
    concat:
      '<%= yeoman.dist %>/<%= isocket.api.version %>/store.js': [
        '.tmp/scripts/store.js'
      ]
    s3:
      key: "***REMOVED***"
      secret: '***REMOVED***'
      bucket: 'buyads-whitelabel'
      access: 'public-read'
      upload: [{
        src: '<%= yeoman.dist %>/<%= isocket.api.version %>/front.js'
        dest: '<%= isocket.api.version %>/<%= build %>/front.js'
        gzip: true
        headers:
          "Cache-Control": "max-age=94608000" # 3 years
      },
      {
        src: '<%= yeoman.dist %>/<%= isocket.api.version %>/store.js'
        dest: '<%= isocket.api.version %>/store.js'
        gzip: true
      }
      ]

    bumpup:
      files: [ 'package.json', 'component.json' ]
    tagrelease:
      file: 'package.json'

    replace:
      dist:
        options:
          variables:
            'API_HOST': '<%= isocket.api.host.prod %>'
            'BUILD': '<%= build %>'
            'CDN': '<%= isocket.cdn.prod %>'
            'VERSION': '<%= isocket.api.version %>'
        files: [
          expand: true
          flatten: true
          src: ['<%= yeoman.dist %>/<%= isocket.api.version %>/store.js']
          dest: '<%= yeoman.dist %>/<%= isocket.api.version %>/'
        ]
      server:
        options:
          variables:
            'API_HOST': '<%= isocket.api.host.dev %>'
            'BUILD': '../dist/<%= isocket.api.version %>' #YOLO
            'CDN': '<%= isocket.cdn.dev %>'
            'VERSION': '<%= isocket.api.version %>'
        files: [{
          expand: true
          flatten: true
          src: ['<%= yeoman.dist %>/<%= isocket.api.version %>/store.js']
          dest: '<%= yeoman.dist %>/<%= isocket.api.version %>/'
          },
          {
            expand: true
            flatten: true
            src: ['<%= yeoman.dist %>/index.html']
            dest: '<%= yeoman.dist %>/'
          }
        ]
    grunticon:
      options:
        src: "<%= yeoman.app %>/images/"
        dest: "<%= yeoman.dist %>/images/"
        previewhtml: "icons.html"


  grunt.registerTask 'server', (target) ->
    if target is 'dist'
      return grunt.task.run [
        'build',
        'replace:server',
        'open',
        'connect:dist:keepalive'
      ]

    grunt.task.run [
      'clean:server',
      'coffee:dist',
      # 'compass:server',
      'replace:server',
      'livereload-start',
      'connect:livereload',
      'open',
      'regarde'
    ]

  grunt.registerTask 'deploy', (user, build, type) ->
    releaseTypes = ["major","minor", "patch", "build"]

    if user is 'jenkins' and !isNaN(build) and releaseTypes.indexOf(type) != -1
      grunt.config.set "build", build

      grunt.task.run [
        'replace:dist',
        'bumpup:' + type,
        'tagrelease',
        's3'
      ]

  grunt.registerTask 'test', [
    'clean:server',
    'coffee',
    # 'compass',
    'connect:test',
    'mocha'
  ]

  grunt.registerTask 'build', [
    'clean:dist',
    'coffee',
    # 'compass:dist',
    'grunticon',
    'useminPrepare',
    'requirejs',
    'imagemin',
    'htmlmin',
    'concat',
    'cssmin',
    'uglify:dist',
    'usemin'
  ]

  grunt.registerTask 'default', [
    'jshint',
    'coffeelint',
    'test',
    'build'
  ]

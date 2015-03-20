mountFolder = (connect, dir) ->
  connect.static require('path').resolve(dir)

module.exports = (grunt) ->
  # load all grunt tasks
  require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks

  # configurable paths
  yeomanConfig =
    app: 'app'
    tmp: '.tmp'
    dist: 'dist'

  isocketConfig =
    api:
      version: 'v0'
      host:
        dev: 'f.dev/wl'
        prod: 'f.isocket.com/wl'
    cdn:
      dev: 'whitelabel.dev'
      prod: 'whitelabel.buyads.com'
      prodSSL: '**REMOVED**.cloudfront.net'
    wl:
      host:
        dev: 'buyads.dev/wl/index.php/order'
        prod: 'www.buyads.com/wl/index.php/order'

  grunt.initConfig
    yeoman: yeomanConfig
    isocket: isocketConfig

    regarde:
      coffee:
        files: ['<%= yeoman.app %>/scripts/{,*/}*.coffee']
        tasks: ['coffeelint:dist', 'coffee:dist']

      coffeeTest:
        files: ['test/spec/{,*/}*.coffee', 'test/helpers/{,*/}*.coffee']
        tasks: ['coffeelint:test', 'coffee:test']

      compass:
        files: ['<%= yeoman.app %>/styles/{,*/}*.{scss,sass}']
        tasks: ['compass']

    clean:
      dist: ['<%= yeoman.tmp %>', '<%= yeoman.dist %>']
      server: '<%= yeoman.tmp %>'

    coffee:
      options:
        bare: true
      dist:
        files: [
          expand: true,
          cwd: '<%= yeoman.app %>/scripts',
          src: '**/*.coffee',
          dest: '<%= yeoman.tmp %>/scripts',
          ext: '.js'
        ]
      test:
        files: [
          expand: true,
          cwd: 'test',
          src: '**/*.coffee',
          dest: '<%= yeoman.tmp %>/test'
          ext: '.js'
        ]

    coffeelint:
      options:
        'max_line_length':
          'level': 'warn'
      dist: [
        'Gruntfile.coffee',
        '<%= yeoman.app %>/scripts/*.coffee'
        ]
      test: [
        'test/spec/*.coffee'
      ]

    compass:
      options:
        sassDir: '<%= yeoman.app %>/styles'
        cssDir: '<%= yeoman.tmp %>/styles'
        imagesDir: '<%= yeoman.app %>/images'
        javascriptsDir: '<%= yeoman.app %>/scripts'
        fontsDir: '<%= yeoman.app %>/styles/fonts'
        importPath: 'components'
        relativeAssets: true
      dist:
        options:
          outputStyle: 'compressed'
          noLineComments: true
      server:
        options:
          debugInfo: true
          trace: true

    connect:
      test:
        options:
          port: 8000
          hostname: '127.0.0.1'

    # Ref: https://github.com/jrburke/r.js/blob/master/build/example.build.js
    requirejs:
      dist:
        options:
          baseUrl: '<%= yeoman.tmp %>/scripts'
          # paths relative to baseUrl
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
          mainConfigFile: '<%= yeoman.tmp %>/scripts/front.js'

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
          '<%= yeoman.dist %>/styles/buyads-whitelabel.css': [
            '<%= yeoman.tmp %>/styles/{,*/}*.css',
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
        '<%= yeoman.tmp %>/scripts/store.js'
      ]

    s3:
      key: '**REMOVED**'
      secret: '**REMOVED**'
      bucket: '**REMOVED**'
      access: 'public-read'
      upload: [
        src: '<%= yeoman.dist %>/<%= isocket.api.version %>/front.js'
        dest: '<%= isocket.api.version %>/<%= build %>/front.js'
        gzip: true
        headers:
          'Cache-Control': 'max-age=94608000' # 3 years
      ,
        src: '<%= yeoman.dist %>/<%= isocket.api.version %>/store.js'
        dest: '<%= isocket.api.version %>/store.js'
        gzip: true
      ]

    bumpup:
      files: [ 'package.json', 'bower.json' ]

    tagrelease:
      file: 'package.json'

    replace:
      dist:
        options:
          variables:
            WL_HOST: '<%= isocket.wl.host.prod %>'
            API_HOST: '<%= isocket.api.host.prod %>'
            BUILD: '<%= build %>'
            CDN: '<%= isocket.cdn.prod %>'
            CDN_SSL: '<%= isocket.cdn.prodSSL %>'
            VERSION: '<%= isocket.api.version %>'
        files: [
          expand: true
          flatten: true
          src: [
            '<%= yeoman.dist %>/<%= isocket.api.version %>/store.js',
            '<%= yeoman.dist %>/<%= isocket.api.version %>/front.js'
          ]
          dest: '<%= yeoman.dist %>/<%= isocket.api.version %>/'
        ]
      server:
        options:
          variables:
            WL_HOST: '<%= isocket.wl.host.dev %>'
            API_HOST: '<%= isocket.api.host.dev %>'
            BUILD: '../dist/<%= isocket.api.version %>' #YOLO
            CDN: '<%= isocket.cdn.dev %>'
            CDN_SSL: '<%= isocket.cdn.dev %>'
            VERSION: '<%= isocket.api.version %>'
        files: [
          {
            expand: true
            flatten: true
            src: [
              '<%= yeoman.dist %>/<%= isocket.api.version %>/store.js',
              '<%= yeoman.dist %>/<%= isocket.api.version %>/front.js'
            ]
            dest: '<%= yeoman.dist %>/<%= isocket.api.version %>/'
          },
          {
            expand: true
            flatten: true
            src: ['<%= yeoman.dist %>/index.html']
            dest: '<%= yeoman.dist %>/'
          }
        ]
      test:
        options:
          variables:
            API_HOST : '<%= isocket.api.host.dev %>'
            BUILD    : '../dist/<%= isocket.api.version %>' #YOLO
            CDN      : '<%= isocket.cdn.dev %>'
            CDN_SSL  : '<%= isocket.cdn.dev %>'
            VERSION  : '<%= isocket.api.version %>'
        files: [{
          expand: true
          flatten: true
          src: ['<%= yeoman.tmp %>/scripts/store.js']
          dest: '<%= yeoman.tmp %>/scripts/'
        }]

    grunticon:
      options:
        src: '<%= yeoman.app %>/images/'
        dest: '<%= yeoman.dist %>/images/'
        previewhtml: 'icons.html'

    mocha:
      all:
        options:
          run: true
          urls: ['http://<%= connect.test.options.hostname %>:<%= connect.test.options.port %>/test/store.html']

    concurrent:
      build: ['coffee:dist', 'compass:dist']

  grunt.registerTask 'server', (target) ->
    if target is 'dist'
      grunt.task.run [
        'build',
        'replace:server'
      ]
    else
      grunt.task.run [
        'clean:server',
        'coffee:dist',
        'compass:server',
        'replace:server',
        'regarde'
      ]

  grunt.registerTask 'deploy', (user, build, type) ->
    releaseTypes = ['major','minor', 'patch', 'build']

    if user is 'jenkins' and !isNaN(build) and releaseTypes.indexOf(type) != -1
      grunt.config.set 'build', build

      grunt.task.run [
        'replace:dist',
        'bumpup:' + type,
        'tagrelease',
        's3'
      ]

  grunt.registerTask 'test', [
    'coffeelint:test',
    'clean:server',
    'coffee',
    'replace:test',
    'connect:test',
    'mocha'
  ]

  grunt.registerTask 'build', [
    'clean:dist',
    'concurrent:build',
    'cssmin',
    'grunticon',
    'useminPrepare',
    'requirejs',
    'imagemin',
    'htmlmin',
    'concat',
    'uglify:dist',
    'usemin'
  ]

  grunt.registerTask 'default', [
    'coffeelint',
    'test',
    'build'
  ]

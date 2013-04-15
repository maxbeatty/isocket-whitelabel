require.config
  paths:
    jquery: '../../components/jquery/jquery'
    es5shim: '../../components/es5-shim/es5-shim'
    es5sham: '../../components/es5-shim/es5-sham'
    text: '../../components/requirejs-text/text'
  map:
    '*':
      'flight/component': '../../components/flight/lib/component'
  shim:
    '../../components/flight/lib/index':
      deps: ['jquery', 'es5shim', 'es5sham']
    'app':
      deps: ['../../components/flight/lib/index']

require ['app'], (App) ->
  App.initialize()

  # load cart styles later?
  # load cart calendar styles later?

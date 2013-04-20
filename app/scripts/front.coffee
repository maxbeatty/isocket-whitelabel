require.config
  paths:
    # required dependencies
    jquery: '../../components/jquery/jquery'
    es5shim: '../../components/es5-shim/es5-shim'
    es5sham: '../../components/es5-shim/es5-sham'
    # plugins
    text: '../../components/requirejs-text/text'
    pickadate: '../../components/pickadate/source/pickadate.legacy'
    tab: '../../components/bootstrap/js/bootstrap-tab'
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

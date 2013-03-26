'use strict';

require.config({
  // baseUrl in Gruntfile.coffee is 'app/scripts'
  paths: {
    jquery: '../components/jquery/jquery',
    es5shim: '../components/es5-shim/es5-shim',
    es5sham: '../components/es5-shim/es5-sham',
  },
  map: {
    '*': {
      'flight/component': '../components/flight/lib/component'
    }
  },
  shim: {
    '../components/flight/lib/index': {
      deps: ['jquery', 'es5shim', 'es5sham']
    },
    'app': {
      deps: ['../components/flight/lib/index']
    }
  }
});

require(['app'], function (App) {
  App.initialize();
});

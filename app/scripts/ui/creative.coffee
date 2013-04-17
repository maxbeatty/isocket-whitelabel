"use strict"
define [
  'flight/component',
  'tab'
], (defineComponent, tab) ->
  creative = ->

    @defaultAttrs
      configBtnSelector: '.buyads-config-creative'

    @toggleConfig = (e) ->
      $(e.target).toggleClass('is-active pickadate__input--active')
        .next()
        .toggleClass('pickadate__holder--opened pickadate__holder--focused')


    ###
    TODO:
      - on click closeBtnFooter, toggleConfig
      - on click saveBtnFooter, saveValueToHidden && toggleConfig
    ###
    @after 'initialize', ->
      @on 'click',
        configBtnSelector: @toggleConfig

  defineComponent creative

"use strict"
define [
  'flight/component',
  'tab'
], (defineComponent, tab) ->
  creative = ->

    @defaultAttrs
      configBtnSelector: '.buyads-config-creative'
      closeBtnSelector: '.pickadate__button--clear'
      saveBtnSelector: '.pickadate__button--today'

    @toggleConfig = (e) ->
      # change big button state
      @select('configBtnSelector').toggleClass('is-active pickadate__input--active')
        .next()
        # change state of popover
        .toggleClass('pickadate__holder--opened pickadate__holder--focused')

    ###
    TODO:
      - on click saveBtnFooter, saveValueToHidden && toggleConfig
    ###
    @after 'initialize', ->
      @on 'click',
        configBtnSelector: @toggleConfig
        closeBtnSelector: @toggleConfig

  defineComponent creative

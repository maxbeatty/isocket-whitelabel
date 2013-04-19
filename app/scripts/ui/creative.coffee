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
      @trigger 'uiNeedsFilepicker', e.target

      # change big button state
      $(e.target).toggleClass('is-active pickadate__input--active')
        .next()
        # change state of popover
        .toggleClass('pickadate__holder--opened pickadate__holder--focused')

      # TODO: if file was uploaded, show upload tab

    @closeConfig = (e) ->
      $(e.target).parents('.pickadate__holder').prev().trigger('click')

    @updateCreativeTag = (e) ->
      # is upload tab active?
      $activeTab = $(e.target).parent().prev().find('.tab-pane.active')

      if $activeTab.attr('id') is 'upload'
        # unless fileUrl dimensions match placement size?
          # show error

        # unless valid click-through? and fileUrl?
          # show error

        # form tag from fileUrl and clickThrough
        # disable paste tab, make textarea readonly

        # @trigger 'dataVerifyCreativeUpload',
        #   fileUrl: #???
        #   clickThrough: #??
      else
        @closeConfig target: $activeTab

    @after 'initialize', ->
      @on 'click',
        configBtnSelector: @toggleConfig
        closeBtnSelector: @closeConfig
        saveBtnSelector: @updateCreativeTag
        # TODO: click outside of creative, close it

  defineComponent creative

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
      # right now, last shown tab will show

    @closeConfig = (e) ->
      $(e.target).parents('.pickadate__holder')
        .find('.alert').addClass('hidden').end() # hide shown error messages
        .prev().trigger('click')

    @updateCreativeTag = (e) ->
      # is upload tab active?
      $activeTab = $(e.target).parent().prev().find('.tab-pane.active')

      if $activeTab.attr('id') is 'upload'
        fileUrlInput = $activeTab.find '[name="buyadsFilepicker"]'
        clickThroughInput = $activeTab.find '[name="buyadsClickThrough"]'

        if fileUrlInput.val().length > 0 and clickThroughInput[0].validity.valid
          @trigger 'uiNeedsCreativeTag', data
        else
          @trigger 'uiShowCreativeError', $activeTab

        # @trigger 'dataValidateCreative',
        #   fileUrl: $activeTab.find '[name="buyadsFilepicker"]'
        #   clickThrough: $activeTabfind '[name="buyadsClickThrough"]'

        # form tag from fileUrl and clickThrough
        # disable paste tab, make textarea readonly
      else
        @closeConfig target: $activeTab

    @showError = (e, tab) ->
      $(tab).find('.alert').removeClass 'hidden'

    @after 'initialize', ->
      @on 'click',
        configBtnSelector: @toggleConfig
        closeBtnSelector: @closeConfig
        saveBtnSelector: @updateCreativeTag
        # TODO: click outside of creative, close it

      @on 'uiShowCreativeError', @showError

  defineComponent creative

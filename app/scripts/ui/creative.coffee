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

      # TODO: if textarea.val().length > 0 then make green

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
          clickThrough = $(clickThroughInput).val()
          fileUrl = fileUrlInput.val()
          [w, h] = $activeTab.parents('.buyads-cart-item').find('.buyads-placement-dimension')
          width = $(w).text().trim()
          height = $(h).text().trim()

          tag = """
                <a href="CLICK_URL#{clickThrough}" target=_blank>
                  <img width="#{width}px" height="#{height}px" src="#{fileUrl}" />
                </a>
                """

          # disable paste tab
          $activeTab.parents('.tabbable').find('[href="#paste"]').attr('disabled', true)
          # make textarea readonly and assign tag to its value
          $activeTab.prev().find('textarea').val(tag).attr('readonly', true)

          @closeConfig target: $activeTab

        else
          @trigger 'uiShowCreativeError', $activeTab

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

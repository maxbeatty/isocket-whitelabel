"use strict"
define [
  'flight/component',
  'pickadate',
  'jquery'
], (defineComponent, pickadate, $) ->
  cart = ->
    cartRequested = false

    @defaultAttrs
      cartSelector: '.buyads-cart'
      # external to cart
      cartBackdropSelector: '.buyads-cart-backdrop'
      addToCartBtnSelector: '.buyads-add-inv'
      cartBtnSelector: '.buyads-cart-btn'
      # internal to cart
      cartItemsSelector: '.buyads-cart-items'
      cartCloseButtonSelector: '.buyads-cart-close'
      tosCheckboxSelector: '[name="buyadsTosAcceptance"]'
      tosHelpSelector: '.buyads-tos-help'
      emptyCartButtonSelector: '.buyads-empty-cart + .buyads-btn'
      cartPickadateSelector: '.buyads-datepicker'
      removeItemSelector: '.buyads-item-remove'
      cartSubmitSelector: '.buyads-cart-submit'
      cartUserSelector: '.buyads-cart-info'
      cartItemSelector: '.buyads-cart-item'
      impInputSelector: '[name$="Kimps"]'
      dateInputSelector: '[name$="_time"]'
      durationSelector: '[name$="_duration"]'
      fileUploadSelectors: '[name="buyadsFilepicker"], [name="buyadsClickThrough"]'
      allInputSelectors: 'input, textarea, select'
      newUserConfirmationSelector: '.buyads-new-user-confirmation'
      existingUserConfirmationSelector: '.buyads-existing-user-confirmation'


    @requestCart = ->
      @trigger 'uiCartRequested' unless cartRequested

    @launchCart = (e, data) ->
      @$node.append data.markup

      cartRequested = true

      @toggleCart()

    @toggleCart = ->
      if cartRequested
        @select('newUserConfirmationSelector').hide()
        @select('existingUserConfirmationSelector').hide()

        @select('cartSelector').toggleClass 'is-open'
      else
        @requestCart()

    @submitCart = (e) ->
      @select('allInputSelectors').removeClass('error')
      @trigger 'uiCartSubmitted',
        data: @collectCartData()

    @collectCartData = (e) ->
      [
        @select('cartUserSelector')
          .find('input')
          .not(@attr['tosCheckboxSelector'])
          .serialize()
          .replace(/(^|&)buyads\-/g, '$1'),

        @select('cartItemSelector').map (i, item) =>
          $(item).find('input, textarea')
            .not(@attr['dateInputSelector'])
            .not(@attr['durationSelector'])
            .not(@attr['fileUploadSelectors'])
            .map (j, input) =>
              $input = $(input)
              if name = $input.attr('name').match(/-([^\]]+)$/, '')?[1]
                field = switch
                  when name.match(/_submit$/) then name.replace(/_submit$/, '')
                  when name.match(/Kimps$/) then 'impressions'
                  else name

                val = switch
                  when name.match(/Kimps$/) then $input.val() * 1000
                  else $input.val()

                'orders[' + i + '][' + field + ']=' + val

          .get().join '&'
        .get().join '&'
      ].join '&'

    @dismissCart = (e) ->
      # dismiss cart when 'esc' key is pressed
      if e.which is 27 and @select('cartSelector').hasClass 'is-open'
        @toggleCart()

    @toggleTosHelp = (e) ->
      accepted = $(e.target).is ':checked'
      @select('tosHelpSelector').toggleClass('is-accepted', accepted)
        .next().attr('disabled', !accepted)

    @addToCart = (e) ->
      $(e.target).prop('disabled', true).text($(e.target).data('disabled-text'))
      @trigger 'uiCartItemRequested', placement: e.target

    @renderCartItem = (e, data) ->
      # requires cart to be rendered and cartItemsSelector
      @toggleCart()

      @select('cartItemsSelector').prepend data.markup

      @select('cartPickadateSelector').pickadate
        dateMin: true,
        format: 'd mmm, yyyy'
        formatSubmit: 'yyyy-mm-dd'

    # TODO: make sure end date is after end date

    @removeItem = (e) ->
      # TODO: confirm user wants to remove item
      $(e.target).parent().remove()

    @showSubmitErrors = (e, data) ->
      for field, message of data.message
        if field == 'orders'
          for i, errorObject of message
            for subField, subMessage of errorObject
              selector = if subField == 'impressions'
                @attr['impInputSelector']
              else
                "input[name*=\"#{subField}\"]"

              @displayError $(@select('cartItemSelector')[i])
                .find(selector), subMessage
        else
          @displayError @select('cartUserSelector')
            .find("input[name*=\"#{field}\"]"), message

    @displayError = (elem, message) ->
      $(elem).addClass('is-invalid')
      # TODO: do something awesome with these error messages
      # $(elem).val(message)

    @confirmPurchase = (e, data) ->
      orderCount = data.orders.length
      @select('cartItemSelector').remove();

      messageSelector = if data.registered
        'newUserConfirmationSelector'
      else
        'existingUserConfirmationSelector'

      @select(messageSelector).show()

      @select('addToCartBtnSelector')
        .prop('disabled', false)
        .text(
          @select('addToCartBtnSelector')
          .data('enabled-text')
        )

    @calcTotal = (e) ->
      @trigger 'uiNeedsSubtotal', e.target

    @updateTotal = (e, data) ->
      $(data.target).removeClass('is-invalid')
        .parents('.buyads-span').find('[class$="subtotal"]').text data.subtotal

    @highlightImpressions = (e, target) ->
      $(target).addClass 'is-invalid'

    @after 'initialize', ->
      @on 'dataCartServed', @launchCart
      @on 'dataCartItemServed', @renderCartItem
      @on 'dataCartSubmittedError', @showSubmitErrors
      @on 'dataCartSubmittedSuccess', @confirmPurchase
      @on 'dataTotalServed', @updateTotal
      @on 'dataInvalidImpressions', @highlightImpressions

      @on 'click',
        cartBtnSelector: @toggleCart
        cartBackdropSelector: @toggleCart
        cartCloseButtonSelector: @toggleCart
        emptyCartButtonSelector: @toggleCart
        addToCartBtnSelector: @addToCart
        removeItemSelector: @removeItem
        cartSubmitSelector: @submitCart

      @on 'change',
        tosCheckboxSelector: @toggleTosHelp
        impInputSelector: @calcTotal

      @on 'keyup', impInputSelector: @calcTotal

      @on document, 'keyup', @dismissCart

  defineComponent cart

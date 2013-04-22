"use strict"
define [
  'flight/component',
  'pickadate',
  'jquery'
], (defineComponent, pickadate, $) ->
  cart = ->
    cartRequested = false
    invalidInput = 'is-invalid'

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
      # order confirmation
      orderConfirmationSelector: '.buyads-confirmation'
      existingUserConfirmationSelector: '.buyads-existing'
      newUserConfirmationSelector: '.buyads-new'
      errorMsgListSelector: '.alert-error ul'


    @requestCart = ->
      @trigger 'uiCartRequested' unless cartRequested

    @launchCart = (e, data) ->
      @$node.append data.markup

      cartRequested = true

      # assume user is addressing their mistake (makes form look nice before submitting)
      @select('cartSelector').on 'focus', '.'+invalidInput, (e) =>
        @forgetInvalid e.target

      @toggleCart()

    @toggleCart = ->
      if cartRequested
        @select('cartSelector').toggleClass 'is-open'
      else
        @requestCart()

    @submitCart = (e) ->
      # disable error states
      @select('allInputSelectors').removeClass(invalidInput)
      @select('errorMsgListSelector').parent().removeClass('is-open')

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
      addToCartBtn = $(e.target)
      addToCartBtn.prop('disabled', true)
        .data('enabled-text', addToCartBtn.text().trim())
        .text(addToCartBtn.data('disabled-text'))

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

      # TODO: re-enable related add-to-cart button

    @showSubmitErrors = (e, data) ->
      errorFields = []
      errorMessages = []

      for field, message of data.message
        if field is 'orders'
          if typeof message is 'string' # one order required case
            errorMessages.push message
          else
            for i, errorObject of message
              for subField, subMessage of errorObject
                selector = if subField is 'impressions'
                  @attr['impInputSelector']
                else
                  "input[name*=\"#{subField}\"]"

                errorFields.push $(@select('cartItemSelector')[i]).find(selector)
                errorMessages.push subMessage
        else
          errorFields.push @select('cartUserSelector').find("input[name*=\"#{field}\"]")
          errorMessages.push message

      unless errorMessages.length is 0
        # highlight invalid inputs
        $.each errorFields, (i, el) =>
          @highlightInvalid null, el

        # add all messages to error alert
        frag = document.createDocumentFragment()
        for e in errorMessages
          msg = document.createElement 'li'
          msg.innerHTML = e
          frag.appendChild msg

        @select('errorMsgListSelector').html(frag)
          .parent().addClass('is-open') # L-A-Z-Y

    @confirmPurchase = (e, data) ->
      orderCount = data.orders.length

      # empty cart
      @select('cartItemSelector').remove();

      # show confirmation message
      @select('orderConfirmationSelector').addClass('alert-success')

      messageSelector = if data.registered
        'newUserConfirmationSelector'
      else
        'existingUserConfirmationSelector'

      @select(messageSelector).addClass('is-customer-type')

      @select('addToCartBtnSelector').prop('disabled', false)
        .text(@select('addToCartBtnSelector').data('enabled-text'))

    @calcTotal = (e) ->
      @trigger 'uiNeedsSubtotal', e.target

    @updateTotal = (e, data) ->
      $(data.target).removeClass(invalidInput)
        .parents('.buyads-span').find('[class$="subtotal"]').text data.subtotal

    @highlightInvalid = (e, target) ->
      $(target).addClass invalidInput

    @forgetInvalid = (target) ->
      $(target).removeClass invalidInput

    @after 'initialize', ->
      @on 'dataCartServed', @launchCart
      @on 'dataCartItemServed', @renderCartItem
      @on 'dataCartSubmittedError', @showSubmitErrors
      @on 'dataCartSubmittedSuccess', @confirmPurchase
      @on 'dataTotalServed', @updateTotal
      @on 'dataInvalidImpressions', @highlightInvalid

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

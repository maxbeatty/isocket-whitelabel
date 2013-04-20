"use strict"
define [
  'flight/component',
  'pickadate',
  'jquery'
], (defineComponent, pickadate, $) ->
  cart = ->
    cartRequested = false
    cartEmpty = true

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

    @requestCart = ->
      @trigger 'uiCartRequested' unless cartRequested

    @launchCart = (e, data) ->
      @$node.append data.markup

      cartRequested = true

      @toggleCart()

    @toggleCart = ->
      if cartRequested
        @select('cartSelector').toggleClass 'is-open'
      else
        @requestCart()

    @submitCart = (e) ->
      @trigger 'uiCartSubmitted',
        data: @collectCartData()

    @collectCartData = (e) ->
      [
        @select('cartUserSelector')
          .find('input')
          .serialize()
          .replace(/(^|&)buyads\-/g, '$1'),

        @select('cartItemSelector').map (i, item) ->
          $(item).find('input').map (j, input) ->
            $input = $(input)
            if name = $input.attr('name').match(/\[([^\]]+)\]$/, '')?[1]
              val = if name.match(/impression/)
                $input.val() * 1000
              else
                $input.val() || ''

              'orders[' + i + '][' + name + ']=' + val

          .get().join '&'
        .get().join '&'
      ].join '&'

    @dismissCart = (e) ->
      # dismiss cart when 'esc' key is pressed
      if e.which is 27 and @select('cartSelector').hasClass 'is-open'
        @toggleCart()

    @toggleTosHelp = (e) ->
      accepted = $(e.target).is ':checked'
      @select('tosHelpSelector').toggleClass('is-accepted', accepted).next().attr('disabled', !accepted)

    @addToCart = (e) ->
      $(e.target).prop('disabled', true).text($(e.target).data('disabled-text'))
      @trigger 'uiCartItemRequested', placement: e.target

    @removeFromCart = (e) ->
      # remove html from cartItemsSelector
      # TODO: cartEmpty = true if cart is empty
      # TODO: change empty button back to empty state

    @renderCartItem = (e, data) ->
      # requires cart to be rendered and cartItemsSelector
      @toggleCart()

      # No clue why this doesn't work
      @select('cartItemsSelector').prepend data.markup

      @select('cartPickadateSelector').pickadate
        dateMin: true,
        format: 'd mmm, yyyy'

      cartEmpty = false
      # TODO: change empty button text to encourage adding more

    # TODO: make sure end date is after end date

    @removeItem = (e) ->
      # TODO: confirm user wants to remove item
      $(e.target).parent().remove()

    @showSubmitErrors = (e, data) ->
      for field, message of data.message
        if field == 'orders'
          for i, errorObject of message
            for subField, subMessage of errorObject
              @displayError $(@select('cartItemSelector')[i])
                .find("input[name*=\"#{subField}\"]"), subMessage
        else
          @displayError @select('cartUserSelector')
            .find("input[name*=\"#{field}\"]"), message

    @displayError = (elem, message) ->
      # TODO: do something awesome with these error messages
      # $(elem).val(message)

    @confirmPurchase = (e, data) ->
      # TODO: display a confirmation message and instructions on what to do next
      # TODO: clear the cart

    @after 'initialize', ->
      @on 'dataCartServed', @launchCart
      @on 'dataCartItemServed', @renderCartItem
      @on 'dataCartSubmittedError', @showSubmitErrors
      @on 'dataCartSubmittedSuccess', @confirmPurchase

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

      @on document, 'keyup', @dismissCart


  defineComponent cart

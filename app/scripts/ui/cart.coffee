"use strict"
define [
  'flight/component',
  'pickadate'
], (defineComponent, pickadate) ->
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

    @dismissCart = (e) ->
      # dismiss cart when 'esc' key is pressed
      if e.which is 27 and @select('cartSelector').hasClass 'is-open'
        @toggleCart()

    @toggleTosHelp = (e) ->
      @select('tosHelpSelector').toggleClass 'is-accepted', $(e.target).is ':checked'

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

    @after 'initialize', ->
      @on 'dataCartServed', @launchCart
      @on 'dataCartItemServed', @renderCartItem

      @on 'click',
        cartBtnSelector: @toggleCart
        cartBackdropSelector: @toggleCart
        cartCloseButtonSelector: @toggleCart
        emptyCartButtonSelector: @toggleCart
        addToCartBtnSelector: @addToCart

      @on 'change',
        tosCheckboxSelector: @toggleTosHelp

      @on document, 'keyup', @dismissCart


  defineComponent cart

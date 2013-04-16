"use strict"
define [
  'flight/component',
  'pickadate'
], (defineComponent, pickadate) ->
  cart = ->
    cartRequested = false

    @defaultAttrs
      cartSelector: '.buyads-cart'
      cartBackdropSelector: '.buyads-cart-backdrop'
      cartItemsSelector: '.buyads-cart-items'
      cartButtonSelector: '.buyads-cart-btn'
      cartPickadateSelector: '.buyads-datepicker'
      cartCloseButtonSelector: '.buyads-cart-close'
      tosCheckboxSelector: '[name="buyadsTosAcceptance"]'
      tosHelpSelector: '.buyads-tos-help'
      emptyCartButtonSelector: '.buyads-empty-cart'

      # @$node.select('cartPickadateSelector').pickadate
      #   dateMin: true,
      #   format: 'd mmm, yyyy'

    @requestCart = ->
      @trigger 'uiCartRequested'

    @launchCart = (e, data) ->
      @$node.append data.markup

      cartRequested = true

      @uiToggleCart()

    @uiToggleCart = ->
      if cartRequested
        @select('cartSelector').toggleClass 'is-open'
      else
        @requestCart()

    @uiDismissCart = (e) ->
      # dismiss cart when 'esc' key is pressed
      if e.which is 27 and @select('cartSelector').hasClass 'is-open'
        @uiToggleCart()

    @uiToggleTosHelp = (e) ->
      @select('tosHelpSelector').toggleClass 'is-accepted', $(e.target).is ':checked'

    @after 'initialize', ->
      @on 'dataCartServed', @launchCart

      @on 'click',
        cartButtonSelector: @uiToggleCart
        cartBackdropSelector: @uiToggleCart
        cartCloseButtonSelector: @uiToggleCart
        emptyCartButtonSelector: @uiToggleCart

      @on 'change',
        tosCheckboxSelector: @uiToggleTosHelp

      @on document, 'keyup', @uiDismissCart


  defineComponent cart

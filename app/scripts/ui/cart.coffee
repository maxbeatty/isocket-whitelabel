"use strict"
define [
  'flight/component',
  'pickadate'
], (defineComponent, pickadate) ->
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
      impInputSelector: '[name$="Kimps"]'

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
      accepted = $(e.target).is ':checked'
      @select('tosHelpSelector').toggleClass('is-accepted', accepted).next().attr('disabled', !accepted)

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

    @calcTotal = (e) ->
      @trigger 'uiNeedsSubtotal', e.target

    @updateTotal = (e, data) ->
      $(data.target).parents('.buyads-span')
        .find('[class$="subtotal"]').text data.subtotal

    @after 'initialize', ->
      @on 'dataCartServed', @launchCart
      @on 'dataCartItemServed', @renderCartItem
      @on 'dataTotalServed', @updateTotal

      @on 'click',
        cartBtnSelector: @toggleCart
        cartBackdropSelector: @toggleCart
        cartCloseButtonSelector: @toggleCart
        emptyCartButtonSelector: @toggleCart
        addToCartBtnSelector: @addToCart
        removeItemSelector: @removeItem

      @on 'change',
        tosCheckboxSelector: @toggleTosHelp
        impInputSelector: @calcTotal

      @on 'keyup', impInputSelector: @calcTotal

      @on document, 'keyup', @dismissCart

  defineComponent cart

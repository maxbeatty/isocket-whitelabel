"use strict"
define [
  'flight/component',
  'jquery',
  'text!../../../app/templates/cart.html',
  'text!../../../app/templates/cart_item.html',
  '../../../app/scripts/utils',
], (defineComponent, $, cartTmpl, cartItemTmpl, utils) ->
  cart = ->
    cartItemTemplate = utils.tmpl cartItemTmpl

    @serveCart = ->
      @trigger 'dataCartServed',
        markup: cartTmpl

    @serveCartItem = (e, data) ->
      inventoryIndex = $(data.placement).data 'inventory'
      placement = YourBuyAdsWhiteLabel.inventory[inventoryIndex]
      placement.index = inventoryIndex

      # don't let location descriptions ramble on
      placement.location.slice(0, 70) + '...' if placement.location.length > 70

      # TODO: allow user to select quick package before adding to cart
      placement.package = placement.Packages[0]

      @trigger 'dataCartItemServed',
        markup: cartItemTemplate { p: placement }

    @submitCart = (e, data) ->
      $.ajax 'http://buyads.dev/wl/index.php/order',
        type: 'POST'
        data: data.data
        dataType: 'json'
        error: (xhr) =>
          @trigger 'dataCartSubmittedError', JSON.parse(xhr.responseText).error
        success: (data) =>
          @trigger 'dataCartSubmittedSuccess', data

    @after 'initialize', ->
      @on 'uiCartRequested', @serveCart
      @on document, 'uiCartSubmitted', @submitCart

      @on 'uiCartItemRequested', @serveCartItem

  defineComponent cart

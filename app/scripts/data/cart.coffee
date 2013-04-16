"use strict"
define [
  'flight/component',
  'text!../../../app/templates/cart.html',
  'text!../../../app/templates/cart_item.html',
  '../../../app/scripts/utils',
], (defineComponent, cartTmpl, cartItemTmpl, utils) ->
  cart = ->
    cartItemTemplate = utils.tmpl cartItemTmpl

    @serveCart = ->
      @trigger 'dataCartServed',
        markup: cartTmpl

    @serveCartItem = (e, data) ->
      inventoryIndex = $(data.placement).data 'inventory'
      placement = YourBuyAdsWhiteLabel.inventory[inventoryIndex]
      placement.index = inventoryIndex

      # TODO: allow user to select quick package before adding to cart
      placement.package = placement.Packages[0]

      @trigger 'dataCartItemServed',
        markup: cartItemTemplate { p: placement }

    @after 'initialize', ->
      @on 'uiCartRequested', @serveCart

      @on 'uiCartItemRequested', @serveCartItem

  defineComponent cart

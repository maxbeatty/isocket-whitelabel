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

    @money = (n, t=',', d='.', c=2, displayZeroCents=true) ->
      c = if isNaN(c = Math.abs(c)) then 2 else c
      s = if n < 0 then '-$' else '$'
      i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + ""
      j = if (j = i.length) > 3 then j % 3 else 0

      s += i.substr(0, j) + t if j
      s += i.substr(j).replace /(\d{3})(?=\d)/g, "$1" + t
      cents = Math.abs(n - i).toFixed(c).slice(2)
      s += d + cents if c and cents isnt '00'

      s

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

      placement.package.minqty ?= 0
      placement.initialSubtotal = @money placement.package.minqty * placement.package.price

      @trigger 'dataCartItemServed',
        markup: cartItemTemplate { p: placement }

    @submitCart = (e, data) ->

      # TODO: needs to be PJAX to work-around same origin policy issues?
      # TODO: this should also be read from a config file
      $.ajax 'http://buyads.dev/wl/index.php/order',
        type: 'POST'
        data: data.data
        dataType: 'json'
        error: (xhr) =>
          @trigger 'dataCartSubmittedError', JSON.parse(xhr.responseText).error
        success: (data) =>
          @trigger 'dataCartSubmittedSuccess', data

    @serveSubtotal = (e, impInput) ->
      @trigger 'dataTotalServed',
        subtotal: @money impInput.value * impInput.getAttribute 'data-price'
        target: impInput

    @after 'initialize', ->
      @on 'uiCartRequested', @serveCart
      @on document, 'uiCartSubmitted', @submitCart

      @on 'uiCartItemRequested', @serveCartItem

      @on 'uiNeedsSubtotal', @serveSubtotal

  defineComponent cart

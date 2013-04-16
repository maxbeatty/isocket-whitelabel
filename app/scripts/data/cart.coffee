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

    @after 'initialize', ->
      @on 'uiCartRequested', @serveCart

  defineComponent cart

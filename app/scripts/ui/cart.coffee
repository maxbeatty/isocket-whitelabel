"use strict"
define [
  'flight/component',
  'text!../../../app/templates/cart.html',
  'text!../../../app/templates/cart_item.html',
  '../../../app/scripts/utils',
  'pickadate'
], (defineComponent, cartTmpl, cartItemTmpl, utils, pickadate) ->
  cart = ->
    cartItemTemplate = utils.tmpl cartItemTmpl

    @defaultAttrs
      cartSelector: '.buyads-cart'
      cartBackdropSelector: '.buyads-cart-backdrop'
      cartItemsSelector: '.buyads-cart-items'
      cartButtonSelector: '.buyads-cart-btn'
      cartPickadateSelector: '.buyads-datepicker'
      cartCloseButtonSelector: '.buyads-cart-close'
      tosHelpSelector: '.buyads-tos-help'

    @renderCart = ->
      @$node.append cartTmpl

      @$node.select('cartPickadateSelector').pickadate
        dateMin: true,
        format: 'd mmm, yyyy'

    @uiToggleCart = ->
      @select('cartSelector').toggleClass 'is-open'

    @uiDismissCart = (e) ->
      # dismiss cart when 'esc' key is pressed
      if e.which is 27 and @select('cartSelector').hasClass 'is-open'
        @uiToggleCart()

    @uiToggleTosHelp = (e) ->
      @select('tosHelpSelector').toggleClass 'is-accepted', $(e.target).is ':checked'

    @after 'initialize', ->
      @renderCart()

      @on 'click',
        cartButtonSelector: @uiToggleCart
        cartBackdropSelector: @uiToggleCart
        cartCloseButtonSelector: @uiToggleCart

      @on '[name="buyadsTosAcceptance"]', 'change', @uiToggleTosHelp

      @on document, 'keyup', @uiDismissCart

      return
    return
    #Four main sections of each component
    # Attributes, Functions, Internal Events, External Events.




#     #Component Attributes
#     #define DOM elements to a selector that you'll use in functions within this Component
#     @defaultAttrs
#       labelForClass: ('.nullClass')
#       labelForId: ('#nullId')
#       activeCssClass: ('activated')





#     #functionalities of Component
#     #what this component does based off incoming events from the interior or the exterior of this component.
#     #Note that Flight is event based which is beautiful, because it forces innate organization and logic into the construction of your SPA.
#     @actionThatClickingIdDoes = () ->
#       @select('labelForClass').toggleClass(this.attr.activeCssClass);
#       #this emmits
#       @trigger 'eventToBeSentToExternalComponent'

#     @functionThatOccurs = () ->
#       #functionality that accors when formSubmittal is emmitted from a different DOM Node





#     @after "initialize", ->
#       # events from within the Component
#       #these are functionalities that are begat from within this DOM Node(component)
#       @on "click", labelForId: @actionThatClickingIdDoes





#       # incoming events from other Components
#       #these are function defined above ^ that are triggered externally.
#       @on document, "formSubmittal", @functionthatoccurs


  defineComponent cart

define [
  'data/cart',
  'data/placements',
  'data/filepicker',
  'ui/placements',
  'ui/cart',
  'ui/creative'
], (CartData, PlacementsData, PlacementsUI, CartUI, CreativeUI, FilepickerData) ->
  initialize = ->
    # .buyads-whitelabel-container created by store
    PlacementsUI.attachTo '.buyads-whitelabel-container'
    CartUI.attachTo '.buyads-whitelabel-container'
    CartData.attachTo '.buyads-whitelabel-container'
    PlacementsData.attachTo '.buyads-whitelabel-container'

    CreativeUI.attachTo '.buyads-whitelabel-container'
    FilepickerData.attachTo '.buyads-whitelabel-container'

    return

  initialize: initialize

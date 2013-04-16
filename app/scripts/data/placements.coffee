"use strict"
define [
  'flight/component',
  'text!../../styles/buyads_whitelabel.css'
  'text!../../../app/templates/placements.html',
  '../../../app/scripts/utils'
], (defineComponent, appStyle, placementsTmpl, utils) ->
  placements = ->
    template = utils.tmpl placementsTmpl

    @serveStyles = ->
      @trigger 'dataStylesServed',
        markup: '<style type="text/css">' + appStyle + '</style>'

    @servePlacements = ->
      @off document, 'dataInventory'

      @trigger 'dataPlacementsServed',
        markup: template zones: YourBuyAdsWhiteLabel.inventory

    @pollInventory = ->
      if YourBuyAdsWhiteLabel.inventory
        @trigger document, 'dataInventory'
      else
        # poll for IE8
        setTimeout (=> @pollInventory()), 500

    @after 'initialize', ->
      @on 'uiStylesRequested', @serveStyles

      # listen for API response
      @on document, 'dataInventory', @render
      # check to see if it came already
      @pollInventory()

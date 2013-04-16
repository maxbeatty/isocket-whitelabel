"use strict"
define [
  'flight/component'
], (defineComponent) ->

  placements = ->

    @requestStyles = ->
      @trigger 'uiStylesRequested'

    @renderStyles = (e, data) ->
      @$node.before data.markup

    @renderPlacements = (e, data) ->
      @$node.prepend data.markup

    @after 'initialize', ->
      @on 'dataStylesServed', @renderStyles
      @on 'dataPlacementsServed', @renderPlacements

      @requestStyles()


  defineComponent placements

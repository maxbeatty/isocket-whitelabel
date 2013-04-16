"use strict"
define [
  'flight/component'
], (defineComponent) ->

  placements = ->

    @renderStyles = (e, data) ->
      @$node.before data.markup

    @renderPlacements = (e, data) ->
      @$node.prepend data.markup

    @after 'initialize', ->
      @on 'dataPlacementsServed', @renderPlacements
      @on 'dataStylesServed', @renderStyles

  defineComponent placements

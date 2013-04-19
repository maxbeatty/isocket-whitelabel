"use strict"
define [
  'flight/component',
  ], (defineComponent) ->
    creative = ->

      @validate = (e, data) ->
        console.log data


      @createTag = (fileUrl, clickThrough) ->
        # TODO: get w and h from placement
        """
        <a href="CLICK_URL#{clickThrough}" target=_blank>
          <img width="#{w}px" height="#{h}px" src="#{fileUrl}" />
        </a>
        """


      @after 'initialize', ->
        @on 'dataValidateCreative', @validate

    defineComponent creative

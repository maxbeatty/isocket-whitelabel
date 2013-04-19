"use strict"
define ['flight/component'], (defineComponent) ->
  filepicker = ->

    @loadFp = ->
      # load filepicker library (unless already available)
      # note: this is all translated from their minified snippet
      unless window.filepicker
        scriptNode = document.createElement "script"
        scriptNode.type = "text/javascript"
        scriptNode.async = !0
        scriptNode.src = (if "https:" is document.location.protocol then "https:" else "http:") + "//api.filepicker.io/v1/filepicker.js"

        firstScript = document.getElementsByTagName("script")[0]
        firstScript.parentNode.insertBefore scriptNode, firstScript

        d = {}
        d._queue = []

        e = "pick,pickMultiple,pickAndStore,read,write,writeUrl,export,convert,store,storeUrl,remove,stat,setKey,constructWidget,makeDropPane".split(",")

        f = (a, b) -> -> b.push [a,arguments]

        d[g] = f g, d._queue for g in e

        window.filepicker = d

    @setApiKey = ->
      if window.filepicker
        window.filepicker.setKey 'ASaNLnyxdSiSxzcreIG74z'
      else
        setTimeout (=> @setApiKey()), 100

    @constructWidget = (e, el) ->
      # find filepicker input and construct based on el
      $fpInput = $(el).next().find('[name="buyadsFilepicker"]')

      # construct unless already done for this item
      if jQuery.isEmptyObject $fpInput.data()
        $fpInput.on('change', (e) ->
          console.log e #JSON.stringify(e.fpfile)
        ).data
          'fp-mimetypes' : "image/*"
          'fp-container' : "modal"
          'fp-maxsize' : "1024"
          'fp-services' : "BOX,COMPUTER,DROPBOX,FACEBOOK,GOOGLE_DRIVE,FLICKR,EVERNOTE,GMAIL,URL,PICASA,FTP,WEBDAV"

        window.filepicker.constructWidget $fpInput[0]

    @after 'initialize', ->
      @loadFp()
      @setApiKey()

      @on 'uiNeedsFilepicker', @constructWidget

  defineComponent filepicker

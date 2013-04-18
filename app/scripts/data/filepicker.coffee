"use strict"
define ['flight/component'], (defineComponent) ->
  filepicker = ->

    @after 'initialize', ->
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

  defineComponent filepicker

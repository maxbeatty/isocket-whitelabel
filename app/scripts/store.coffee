# Store is embedded on a publisher's site and loads our latest front

front = document.createElement 'script'
front.async = true
# TODO: set far future caching header for front.js
# TODO: rev front.js and update path here
# TODO: allow to be loaded over HTTPS
front.src = 'http://whitelabel.buyads.com/front.js'

whitelabel = document.getElementById 'buyads-whitelabel'
whitelabel.parentNode.insertBefore front, whitelabel.nextSibling

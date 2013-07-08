describe 'Store', ->
  it 'should insert a container div to be populated later', ->
    shop = document.getElementsByClassName 'buyads-whitelabel-container'
    expect(shop.length).toBe(1)

  it 'should async load the front (flight app)', ->
    front = document.getElementById('buyads-whitelabel').nextElementSibling
    expect(front.src).toMatch(/front.js/)

  xit 'should populate the store with data from the API', ->



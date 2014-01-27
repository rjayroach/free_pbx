page = require('webpage').create()
page.open 'http://localhost:3000/mcp_pbx/cdrs', (status) ->
  title = page.evaluate -> document.title
  console.log "Status: #{title}"
  phantom.exit


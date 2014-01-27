

# NOTE: This code is obsolete since there is no search from teh datatable search box
jQuery -> 
  $('#xmcp_pbx_asterisk_cdr_search').click (event) ->
    # Grab the form data and create a filtered url
    form = $("#mcp_pbx_asterisk_cdr_search_f")
    postData = ''
    form.find(":input").each ->
      postData = postData + '&' + $(this).attr("name") + '=' +  $(this).val()

    # Get a reference to the current dataTable and update its data source url to include the filters
    table_id = '#mcp_pbx_' + $('li.cdr-tab.active > a').data('tab-param')
    oTable = $(table_id).dataTable()
    oTable.fnSettings().sAjaxSource = $(table_id).data('source') + postData
    oTable.fnDraw()
    false

  $('#Filters').click (event) ->
    $('#search').toggleClass('hide')
  $('#email').click (event) ->
    #alert getURLParameter('q')
    alert $(this).data('url')



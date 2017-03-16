App.tables = App.cable.subscriptions.create "TablesChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('div#table_records').html('data.html')

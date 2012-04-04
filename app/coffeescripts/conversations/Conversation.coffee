define [
  'use!backbone'
  'jquery.ajaxJSON'
  'jquery.disableWhileLoading'
], (Backbone) ->

  class Conversation extends Backbone.Model
    defaults:
      audience: []

    # we don't currently save the model directly, rather we do inbox actions
    inboxAction: (options) ->
      defaults =
        method: 'POST'
        success: (data) => @list.updateItem(data)
      options = $.extend(true, {}, defaults, options)
      options.data = $.extend(@list.baseData(), options.data ? {})
      ajaxRequest = $.ajaxJSON options.url, options.method, options.data, (data) =>
        options.success?(data)
        @list.updateItem(data)
      # TODO: use $el
      @list.$item(@id).disableWhileLoading(ajaxRequest)

    url: (action='') -> "/conversations/#{@id}/#{action}?#{$.param(@list.baseData())}"
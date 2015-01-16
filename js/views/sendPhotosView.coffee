define ['_','baseView','text!templates/sendPhotos.html'],
(_, BaseView,template)->

  class SendPhotosView extends BaseView
    template:template

    constructor:(query)->
      super


    onRender:()->
      @sendForm()

    onPageBeforeAnimation:()->
      console.log("onPageBeforeAnimation")

    sendForm: ()->
      @$('form.ajax-submit').on('submitted', (e) ->
        xhr = e.detail.xhr
        console.log xhr
        data = e.detail.data
        console.log data
      )
  return SendPhotosView

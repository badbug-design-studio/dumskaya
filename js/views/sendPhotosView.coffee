define ['_','baseView','text!templates/sendPhotos.html'],
(_, BaseView,template)->

  class SendPhotosView extends BaseView
    template:template

    constructor:(query)->
      super


    onRender:()->

    onPageBeforeAnimation:()->
      console.log("onPageBeforeAnimation")

  return SendPhotosView

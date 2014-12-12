define ['_','baseView','text!templates/oneItemNews.html'],
  (_, BaseView,template)->

        class OneItamNewsView extends BaseView
          template:template
          domTabsObj:[]

          constructor:(query)->
            super


          onRender:()->
            console.log "Item"

        return OneItamNewsView

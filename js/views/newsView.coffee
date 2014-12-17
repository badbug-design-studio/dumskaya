define ['_','categoryView','text!templates/news.html'],
  (_, CategoryView,template)->

        class NewsView extends CategoryView
          template:template
          cacheClass:"news"
          itemSelector:".item-content"
#          events:
#            "click .news-list .item-content":"openOneItem"

          constructor:(query)->
            super


          onRender:()->
            @initInfinitScroll()
            @handleOnClickItem()





          infiniteStart: ()->
            console.log "infinite"







        return NewsView

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
#            @initInfinitScroll()
            @handleOnClickItem()

          appendEl:()->
            return @$('#tab1 ul')

          infiniteScrollSelector:()->
            return  @$('#tab1 .infinite-scroll-preloader')





          infiniteStart: ()->
            console.log "infinite"







        return NewsView

define ['_','categoryView','text!templates/tv.html'],
  (_, CategoryView,template)->

        class TVView extends CategoryView
          template:template
          cacheClass:"tv"
          itemSelector:".item-content"
#          events:
#            "click .news-list .item-content":"openOneItem"

          constructor:(query)->
            super


          onRender:()->
            @initInfinitScroll()
            @handleOnClickItem()




          appendEl:()->
             return @$('#tab3 ul')

          infiniteScrollSelector:()->
             return  @$('#tab3 .infinite-scroll-preloader')




        return TVView

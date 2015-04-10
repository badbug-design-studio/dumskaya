define ['_','categoryView','text!templates/tv.html'],
  (_, CategoryView,template)->

        class SportView extends CategoryView
          template:template
          cacheClass:"sport"
          itemSelector:".item-content"
#          events:
#            "click .news-list .item-content":"openOneItem"

          constructor:(query)->
            super


          onRender:()->
            @initCustomInfinitScroll()



          appendEl:()->
             return @$('#tab4 ul')

          infiniteScrollSelector:()->
             return  @$('#tab4 .infinite-custom-preloader')




        return SportView

define ['_','categoryView','text!templates/blogs.html'],
  (_, CategoryView,template)->

        class BlogsView extends CategoryView
          template:template
          cacheClass:"blogs"
          itemSelector:".item-content"
#          events:
#            "click .blogs-list .item-content":"openOneItem"

          constructor:(query)->
            super


          onRender:()->
            @initInfinitScroll()
            @handleOnClickItem()


          appendEl:()->
             return @$('#tab2 ul')


          infiniteScrollSelector:()->
             return  @$('#tab2 .infinite-scroll-preloader')



        return BlogsView

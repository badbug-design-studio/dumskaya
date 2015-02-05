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
            setTimeout(()=>
              @initCustomInfinitScroll()
            ,0)
            @handleOnClickItem()


          appendEl:()->
             return @$('#tab2 ul')


          infiniteScrollSelector:()->
             return  @$('#tab2 .infinite-custom-preloader')



        return BlogsView

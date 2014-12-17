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


          infiniteStart: ()->
            console.log "infinite"



        return BlogsView

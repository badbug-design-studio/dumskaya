define ['_','categoryView','text!templates/news.html'],
  (_, CategoryView,template)->

        class NewsView extends CategoryView
          template:template
          events:
            "click .item-content":"openOneItem"

          constructor:(query)->
            super


          onRender:()->

          openOneItem:(event)=>
            index=@$(event.target).parents('.item-content').data('index')
            baseApplication.router.loadPage('oneItemNews')


        return NewsView

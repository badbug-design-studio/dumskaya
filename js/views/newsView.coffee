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
            baseApplication.router.loadPage('oneItemNews')
            console.log event
            console.log @$(event.target)[0]








        return NewsView

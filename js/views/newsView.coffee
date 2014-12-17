define ['_','categoryView','text!templates/news.html'],
  (_, CategoryView,template)->

        class NewsView extends CategoryView
          template:template
          events:
            "click .item-content":"openOneItem"

          constructor:(query)->
            super


          onRender:()->
            @$('.infinite-scroll').on('infinite',  @infiniteStart.bind(@))


          openOneItem:(event)=>
            index=@$(event.target).parents('.item-content').data('index')
            console.log(baseApplication.cache.news[index])
            @model.listView.navBarDom.removeClass("navbar-fade-in").addClass("navbar-fade-out")
            baseApplication.router.loadPage('oneItemNews')
            console.log event
            console.log @$(event.target)[0]

          infiniteStart: ()->
            console.log "infinite"







        return NewsView

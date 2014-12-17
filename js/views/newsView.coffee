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
            @$('#main-navbar .buttons-row').removeClass("navbar-fade-in")
            @$('#main-navbar .buttons-row').addClass("navbar-fade-out")
            baseApplication.router.loadPage('oneItemNews')
            console.log event
            console.log @$(event.target)[0]

          infiniteStart: ()->
            console.log "infinite"







        return NewsView

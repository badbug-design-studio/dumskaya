define ['_','categoryView','text!templates/blogs.html'],
  (_, CategoryView,template)->

        class NewsView extends CategoryView
          template:template
          events:
            "click .item-content":"openOneItem"
#            "refresh .pull-to-refresh-content":"updateCurrentTab"

          constructor:(query)->
            super


          onRender:()->
            @$('.infinite-scroll').on('infinite',  @infiniteStart.bind(@))

          openOneItem:(event)=>
             @$('#main-navbar .buttons-row').removeClass("navbar-fade-in")
             @$('#main-navbar .buttons-row').addClass("navbar-fade-out")
             baseApplication.router.loadPage('oneItemNews')
          infiniteStart: ()->
            console.log "infinite"



        return NewsView

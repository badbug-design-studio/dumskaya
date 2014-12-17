define ['_','categoryView','text!templates/tv.html'],
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

          infiniteStart: ()->
            console.log "infinite"

          openOneItem:(event)=>
             @$('#main-navbar .buttons-row').removeClass("navbar-fade-in")
             @$('#main-navbar .buttons-row').addClass("navbar-fade-out")
             baseApplication.router.loadPage('oneItemNews')




        return NewsView

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
             @model.listView.navBarDom.removeClass("navbar-fade-in").addClass("navbar-fade-out")
             baseApplication.router.loadPage('oneItemNews')




        return NewsView

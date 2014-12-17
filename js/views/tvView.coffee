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
            @initInfinitScroll()


          initInfinitScroll:()->
             cT=@model.listView.model.currentTab-1
             loading = false;
             @model.listView.domTabsObj[cT].on('infinite',  ()->
               if (loading) then return;
               console.log 'infinite'
 #              // Set loading flag
               loading = true;
               setTimeout(()->
                 loading=false
               ,1000)
             )

          infiniteStart: ()->
            console.log "infinite"

          openOneItem:(event)=>
             @model.listView.navBarDom.removeClass("navbar-fade-in").addClass("navbar-fade-out")
             baseApplication.router.loadPage('oneItemNews')




        return NewsView

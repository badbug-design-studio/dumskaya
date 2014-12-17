define ['_','categoryView','text!templates/tv.html'],
  (_, CategoryView,template)->

        class NewsView extends CategoryView
          template:template
#          events:
#            "refresh .pull-to-refresh-content":"updateCurrentTab"

          constructor:(query)->
            super


          onRender:()->
            @$('.infinite-scroll').on('infinite',  @infiniteStart.bind(@))

          infiniteStart: ()->
            console.log "infinite"






        return NewsView

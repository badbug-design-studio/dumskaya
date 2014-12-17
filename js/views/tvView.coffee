define ['_','categoryView','text!templates/tv.html'],
  (_, CategoryView,template)->

        class NewsView extends CategoryView
          template:template
#          events:
#            "refresh .pull-to-refresh-content":"updateCurrentTab"

          constructor:(query)->
            super


          onRender:()->








        return NewsView

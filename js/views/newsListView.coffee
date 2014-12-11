define ['_','baseView','text!templates/newsList.html'],
  (_, BaseView,template)->

        class NewsListView extends BaseView
          template:template
          model:
            name:"Awesome"

          constructor:(query)->
            super
            @render()


          onPageBeforeAnimation:()->
            console.log("onPageBeforeAnimation")


        return NewsListView

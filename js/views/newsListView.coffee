define ['_','baseView','text!templates/newsList.html'],
  (_, BaseView,template)->

        class IndexView extends BaseView
          template:template

          constructor:(query)->
            super
            @render()


          onPageBeforeAnimation:()->
            console.log("onPageBeforeAnimation")


        return IndexView

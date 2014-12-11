define ['_','baseController'],
  (_, BaseController)->

        class IndexController extends BaseController
          previousTimeString:""

          constructor:(query)->
            super
            console.log(@)

          initPage:()->
            console.log("start page init")


          onPageBeforeAnimation:()->
            console.log("onPageBeforeAnimation")


        return IndexController

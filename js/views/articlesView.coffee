define ['_','categoryView','text!templates/articles.html'],
(_, CategoryView,template)->

  class ArticlesView extends CategoryView
    template:template
    cacheClass:"articles"
    itemSelector:".item-content"

    constructor:(query)->
      super


    onRender:()->
#      @initInfinitScroll()
      @handleOnClickItem()


    appendEl:()->
      return @$('#tab3 ul')

    infiniteScrollSelector:()->
      return  @$('#tab3 .infinite-scroll-preloader')




  return ArticlesView

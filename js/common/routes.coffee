define ['_'],
(_)->
  class Routes

    $: null

    init:->
      @$ = Framework7.$
#      @$(document).on 'pageBeforeInit', (e)=>
#        page = e.detail.page
#        @loadPage(page.name, page.query)

    loadPage:(controllerName, query)->
      require ['./controllers/'+ controllerName + 'Controller'], (Controller)->
        baseApplication.currentController = new Controller(query)
        baseApplication.currentController.initPage()


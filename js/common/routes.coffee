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
      require ['./views/'+ controllerName + 'View'], (View)->
        delete baseApplication['currentView']
        baseApplication.currentView = new View(query)


  return new Routes()


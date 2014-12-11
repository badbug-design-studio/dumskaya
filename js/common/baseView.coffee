define ['_'],
(_)->
  class BaseView
    $: Framework7.$
    template:null
    model: {}
    container:()->
       return @$(baseApplication.mainLayout.selector)
    ###
      animatePages: true
      domCache: false
      dynamicNavbar: true
      linksView: undefined
      swipeBackPage: true
      swipeBackPageActiveArea: 30
      swipeBackPageBoxShadow: true
      swipeBackPageThreshold: 0
    ###
    viewParams: {}

    constructor: (query)->
      if(query && query.model)
        @model = query.model
      if(query && query.viewParams)
        @viewParams = query.viewParams

    onRender:()->
        console.log("ON RENDER!")

    render:()->
      if !@template
        console.error "in current view #{@constructor.name} template was missed"
        return

      compile=_.template(@template)
      @container().append(compile(@model))
      @onRender()



  return BaseView
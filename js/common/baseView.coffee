define ['_'],
(_)->
  class BaseView
    $: Framework7.$
    template:null
    isAnimate:true
    container:()->
       return @$(baseApplication.mainLayout.selector)

    addEventListeners:()->
          @mainListeners() if @mainListeners
          if _.isEmpty(@events)
            return true

          _.each @events, (handler, actionToElement)=>
            elementObj = actionToElement.split(" ")
            event = elementObj[0]
            elementObj.shift()
            elementObj = elementObj.join(" ")
            @$(elementObj).on(event, @[handler])

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
      baseApplication.mainLayout.loadContent(compile(@model),@isAnimate)
#      @container().append(compile(@model)) it  so for layout
      @addEventListeners()
      @onRender()



  return BaseView
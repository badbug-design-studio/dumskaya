define ['require','_'],
(require,_)->
  class BaseView
    $: Framework7.$
    template:null
    isAnimate:true
    container:()->
       return @$(baseApplication.mainLayout.selector)
    isInjectedOnly: false

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


    constructor: (query)->
      if(query && query.model)
        @model = query.model
      if(query && query.viewParams)
        @viewParams = query.viewParams
      @render()


    onRender:()->
        console.log("ON RENDER!")

    render:()->
      if !@template
        console.error "in current view #{@constructor.name} template was missed"
        return
      _.each @viewParams, (param, key)=>
           baseApplication.mainLayout.params[key] = param
      compiledHtml=baseApplication.cache.getCompiledHtml('key',@template,@model)
      if @isInjectedOnly
        @container().html(compiledHtml) #just insert in container
      else
        baseApplication.mainLayout.loadContent(compiledHtml,@isAnimate) #f7 new page comes
      @addEventListeners()
      @onRender()





  return BaseView
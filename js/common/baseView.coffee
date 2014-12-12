define ['require','_'],
(require,_)->
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
      @render()
      @addEventListeners()

    onRender:()->
        console.log("ON RENDER!")

    render:()->
      if !@template
        console.error "in current view #{@constructor.name} template was missed"
        return
      compile=_.template(@template)
      baseApplication.mainLayout.loadContent(compile(@model),@isAnimate)
#      @container().append(compile(@model)) it  so for layout
      @onRender()

    appendCompiledTemplate:(url,data,callback)->
      cT=@.model.currentTab
      require(['text!'+url],(template)=>
        compile= _.template(template)
        result=compile(data)
        console.log @domTabsObj[cT-1]
        @domTabsObj[cT-1].html(result)
        callback() if callback
      );



  return BaseView
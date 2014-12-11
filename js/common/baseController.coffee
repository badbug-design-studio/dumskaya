define ['_'],
(_)->
  class BaseController
    $: Framework7.$
    @model: {}
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
    @viewParams: {}

    constructor: (query)->
      if(query && query.model)
        @model = query.model
      if(query && query.viewParams)
        @viewParams = query.viewParams

    onPageInit: ()->
      console.log("onPageInit")

    onPageBeforeInit: ()->
      console.log "onPageBeforeInit"

    onPageBeforeAnimation: ()->
      console.log "onPageBeforeAnimation"

    onPageAfterAnimation: ()->
      console.log "onPageAfterAnimation"


    onPageBeforeRemove: ()->
      console.log "onPageBeforeRemove"



  return BaseController
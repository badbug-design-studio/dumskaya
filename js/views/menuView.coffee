define ['_','baseView', 'text!templates/menu.html'],
  (_, BaseView, template)->

        class MenuView extends BaseView
          template:template
          isAppendOnly: true
          container:()->
            return @$('.settings-page')

          constructor:(query)->
            super

          onRender:()->
            console.log "Menu"

        return MenuView

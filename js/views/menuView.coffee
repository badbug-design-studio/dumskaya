define ['_','baseView', 'text!templates/menu.html'],
  (_, BaseView, template)->

        class MenuView extends BaseView
          template:template
          isInjectedOnly: true
          container:()->
            return @$('#settings-page')

          constructor:(query)->
            super

          onRender:()->

        return MenuView

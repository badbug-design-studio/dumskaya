define ['_','baseView', 'text!templates/menu.html'],
  (_, BaseView, template)->

        class MenuView extends BaseView
          template:template
          isInjectedOnly: true
          events:
           "touchstart #change-tabs li":"changeSelectedItem"

          container:()->
            return @$('#settings-page')

          constructor:(query)->
            super

          onRender:()->
            @menuLis=@$('#change-tabs li')



          changeSelectedItem:(e)=>
            currentItem=@$(e.target)
            index=currentItem.data('index')
            if index
              baseApplication.f7app.closePanel();
              baseApplication.listView.changeTab(e)
              @menuLis.removeClass('selected')
              currentItem.addClass('selected')

        return MenuView

define ['_','baseView','text!templates/lists.html','mainTabs', 'hammer'],
  (_, BaseView,template,Tabs, Hammer)->

        class ListView extends BaseView
          template:template
          domTabsObj:[]
          model:
            currentTab:1
            name:"Dumskaya"
            tabs:Tabs
          delay: 450
          items:{}
          constructor:(query)->
            super


          onRender:()->
            @elTabsDom7=@$('.tabs')
            @elTabs=@$('.tabs')[0]
            @tabsLinkWidth = window.innerWidth/@model.tabs.length
            @handleTabs()
            @swipeTabsHandle()
            @showCurrentTab()


          handleTabs:()->
            _.each(@model.tabs,(tab,i)=>
              tabDom=@$('#'+tab.id)
              @domTabsObj.push(tabDom)
              tabDom.on('show',  () =>
                @model.currentTab=(i+1)
                @showCurrentTab()
              );
            )

          swipeTabsHandle:()->
            Hammer(@elTabsDom7[0]).on("swipeleft", ()=>
              if(@model.currentTab<@model.tabs.length)
                @model.currentTab++
                baseApplication.f7app.showTab('#tab'+@model.currentTab)
            );
            Hammer(@elTabsDom7[0]).on("swiperight", ()=>
              if(@model.currentTab>1)
                 @model.currentTab--
                 baseApplication.f7app.showTab('#tab'+@model.currentTab)
            );
           showCurrentTab:(needWebTranlate)->

              @changePositionTriagle()
              index=@model.currentTab-1
              tab=@model.tabs[index]
              setTimeout(()=>
                     tab.onShowComplete.apply(@) if tab
              ,@delay)


          onPageBeforeAnimation:()->
            console.log("onPageBeforeAnimation")

          changePositionTriagle:()->
            triangle= @$('.buttons-row .triangle')[0]
            shift = @model.currentTab*@tabsLinkWidth - @tabsLinkWidth/2;
            @$(triangle).transform("translate3d(#{shift}px, 0, 0)")

        return ListView

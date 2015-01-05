define ['_','baseView','app','text!templates/lists.html','mainTabs', 'hammer'],
  (_, BaseView,app,template,Tabs, Hammer)->

        class ListView extends BaseView
          template:template
          domTabsObj:[]
          model:
            currentTab:1
            name:"Думская"
            tabs:Tabs
          delay: 450
          items:{}
          isUpdating:false
          indexes:
            news:0
            blogs:0
            tv:0
            articles:0
          infiniteTabsEventOn:[false,false,false,false]

          events:
            "refresh .pull-to-refresh-content":"updateCurrentTab"
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
              if @isUpdating
                return
              if(@model.currentTab<@model.tabs.length)
                @model.currentTab++
                baseApplication.f7app.showTab('#tab'+@model.currentTab)
            );
            Hammer(@elTabsDom7[0]).on("swiperight", ()=>
              if @isUpdating
                 return
              if(@model.currentTab>1)
                 @model.currentTab--
                 baseApplication.f7app.showTab('#tab'+@model.currentTab)
            );
          showCurrentTab:()->
              @changePositionTriagle()
              index=@model.currentTab-1
              tab=@model.tabs[index]
              console.log tab
              setTimeout(()=>
                     tab.updateItems.apply(@) if tab
              ,@delay)

          updateCurrentTab:()=>
            @isUpdating=true
            index=@model.currentTab-1
            tab=@model.tabs[index]
            console.log tab
            tab.updateItems.call(@,()=>
              app.pullToRefreshDone()
              @isUpdating=false
            ) if tab

          onPageBeforeAnimation:()->
            console.log("onPageBeforeAnimation")

          changePositionTriagle:()->
            triangle= @$('.buttons-row .triangle')[0]
            shift = @model.currentTab*@tabsLinkWidth - @tabsLinkWidth/2;
            @$(triangle).transform("translate3d(#{shift}px, 0, 0)")

        return ListView

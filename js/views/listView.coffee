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
            "refresh #tabs .pull-to-refresh-content":"updateCurrentTab"
            "touchstart #change-tabs a":"changeTab"

          constructor:(query)->
            super


          onRender:()->
            @elTabsDom = document.getElementById('tabs')
            @triangle=  document.getElementById('triangle')
            @ptrEl=  document.getElementById('ptr')
            @elBody=@$('#body')
            @tabsLinkWidth = window.innerWidth/@model.tabs.length
            @cacheTabs()
            @swipeTabsHandle()
            @showCurrentTab()
            document.getElementById('tab1').onscroll =  (event) ->
              # called when the window is scrolled.
              console.log event
              console.log document.body.scrollTop


          cacheTabs:()->
            _.each(@model.tabs,(tab,i)=>
              tabDom=@$('#'+tab.id)
              @domTabsObj.push(tabDom)
            )

          swipeTabsHandle:()->
#            hammer = new Hammer(@elTabsDom);
#            hammer.get('swipe').set({ direction: Hammer.DIRECTION_ALL });

            window.WebPullToRefresh.init({
              ptrEl: @ptrEl
              contentEl: document.getElementById('tab1')
              loadingFunction: @exampleLoadingFunction()
            });

            Hammer(@elTabsDom,{threshold:0}).on("swipeleft", ()=>
              if(@model.currentTab<@model.tabs.length)
                @model.currentTab++
                @showCurrentTab()
            );
            Hammer(@elTabsDom,{threshold:0}).on("swiperight", ()=>
              if(@model.currentTab>1)
                 @model.currentTab--
                 @showCurrentTab()
            );
          exampleLoadingFunction:()->
            return new Promise((resolve, reject)=>
              if(true)
                resolve();
              else
                reject();
            )

          showCurrentTab:()->
              @tabTransition()
              @changePositionTriagle()


              @previousDate=false
              setTimeout(()=>
                     index=@model.currentTab-1
                     tab=@model.tabs[index]
                     console.log 'apply!!!!'
                     tab.updateItems.apply(@) if tab
              ,@delay)

          updateCurrentTab:()=>
            @elBody.addClass('disable-touch')
            index=@model.currentTab-1
            tab=@model.tabs[index]
            @previousDate=false
            tab.updateItems.call(@,()=>
              app.pullToRefreshDone()
              @elBody.removeClass('disable-touch')
            ) if tab

          onPageBeforeAnimation:()->
            console.log("onPageBeforeAnimation")

          changePositionTriagle:()->
            shift = @model.currentTab*@tabsLinkWidth - @tabsLinkWidth/2;
            @triangle.style.webkitTransform ="translate3d(#{shift}px, 0, 0)"

          changeTab:(event)=>
           event.preventDefault()
           newTabIndex= event.target.getAttribute('href').substr(1)
           if(!newTabIndex)
             return
           @model.currentTab=  +newTabIndex
           @showCurrentTab()


          tabTransition:()->
            shift=(@model.currentTab-1)*100;
            @elTabsDom.style.webkitTransform ="translate3d(-#{shift}%, 0, 0)"






        return ListView

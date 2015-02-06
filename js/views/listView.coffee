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
#            "refresh #tabs .pull-to-refresh-content":"updateCurrentTab"
            "touchstart #change-tabs a":"changeTab"

          constructor:(query)->
            super


          onRender:()->
            @elTabsDom = document.getElementById('tabs')
            @triangle=  document.getElementById('triangle')
            @elBody=document.getElementById('body')
            @ptr=document.getElementById('ptr')
            @tabsLinkWidth = window.innerWidth/@model.tabs.length
            @cacheTabs()
            @showCurrentTab()
#            @swipeTabsHandle()



          cacheTabs:()->
            self=this
            _.each(@model.tabs,(tab,i)=>
              tabDom=@$('#'+tab.id)
              baseApplication.helpers.pullToRefreshSwipe.call(self,tabDom[0],@updateCurrentTab,@swipeLeft,@swipeRight)
              @domTabsObj.push(tabDom)
            )

          swipeTabsHandle:()->
            Hammer(@elTabsDom,{threshold:0}).on("swipeleft", ()=>
              console.log 'swipeleft1'

            );
            Hammer(@elTabsDom,{threshold:0}).on("swiperight", ()=>

            );

          swipeLeft:()->
            if(@model.currentTab<@model.tabs.length)
                @model.currentTab++
                @showCurrentTab()


          swipeRight:()->
            if(@model.currentTab>1)
                  @model.currentTab--
                  @showCurrentTab()

          showCurrentTab:()->
                @tabTransition()
                @changePositionTriagle()


                @previousDate=false
                setTimeout(()=>
                       index=@model.currentTab-1
                       tab=@model.tabs[index]
                       console.log 'apply!!!!'
                       if tab
                         tab.updateItems.apply(@)
                       else
                         alert('tab is not defined')
                ,@delay)

          updateCurrentTab:()=>
            self=@
            index=@model.currentTab-1
            tab=@model.tabs[index]
            @previousDate=false
            domEl=@domTabsObj[index]
            tab.updateItems.call(@,()=>
              domEl[0].style.transitionDuration='300ms'
              domEl[0].style.webkitTransform="translate3d(0,0,0)"
              setTimeout(()=>
               domEl[0].style.transitionDuration='0ms'
               @elBody.className=""
               @model.needUpdateScroll=true
              ,300)
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
            @ptr.style.webkitTransform ="translate3d(#{shift}%, 0, 0)"






        return ListView

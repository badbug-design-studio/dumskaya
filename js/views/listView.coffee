define ['_','baseView','app','text!templates/lists.html','mainTabs', 'hammer'],
  (_, BaseView,app,template,Tabs, Hammer)->

        class ListView extends BaseView
          template:template
          domTabsObj:[]
          tabInProgress:false
          shift:0
          model:
            currentTab:1
            name:"Думская"
            tabs:Tabs
          delay: 450
          xDown: null
          yDown: null
          items:{}
          isUpdating:false
          indexes:
            news:0
            blogs:0
            tv:0
            articles:0
          cacheClassesArr: ['news','blogs','tv','articles']

          events:
#            "refresh #tabs .pull-to-refresh-content":"updateCurrentTab"
            "touchstart #change-tabs a.my-custom-tab-link":"changeTab"

          constructor:(query)->
            super


          onRender:()->
            @elTabsDom = document.getElementById('tabs')
            @triangle=  document.getElementById('triangle')
            @elBody=document.getElementById('body')
            @ptr=document.getElementById('ptr')
            @tabsLinks = @$("#change-tabs a");
            @tabsLinkWidth = window.innerWidth/@model.tabs.length
            @cacheTabs()
            @showCurrentTab()
            @onChangeOrientation()
            history.pushState({page: 'lists'})

          handleOnClickItem:(elem,i)->
            Hammer(elem[0]).on("tap", (event) =>
              #fix double tap bug!
              if(@tabInProgress)
                return
              @tabInProgress=true
              index=event.target.getAttribute('data-index')
              if(!index)
                @tabInProgress=false
                return
              model=baseApplication.cache.data[@cacheClassesArr[i]][index]
              model.cacheClass=@cacheClassesArr[i]
              model.index=index
              model.targetDom=event.target
              baseApplication.router.loadPage('oneItem',{model:model},()=>
                @tabInProgress=false
              )
            );

          cacheTabs:()->
            self=this
            _.each(@model.tabs,(tab,i)=>
              tabDom=@$('#'+tab.id)
              @handleOnClickItem(tabDom,i)
              baseApplication.helpers.pullToRefreshSwipe.call(self, tabDom[0],i,@updateCurrentTab,()=>
                  @swipeLeft()
                ,()=>
                  @swipeRight()
              )
              @domTabsObj.push(tabDom)
            )

          swipeLeft:()->
            @resetTabPosition()
            if(@model.currentTab<@model.tabs.length)
                @model.currentTab++
                @showCurrentTab()


          swipeRight:()->
            @resetTabPosition()
            if(@model.currentTab>1)
                  @model.currentTab--
                  @showCurrentTab()

          showCurrentTab:()->
            @tabTransition()
            @changePositionTriagle()
#            @previousDate=false
            setTimeout(()=>
                   index=@model.currentTab-1
                   tab=@model.tabs[index]
                   if tab
                     tab.updateItems.apply(@)
                   else
                     alert('tab is not defined')
            ,@delay)

          updateCurrentTab:(index)=>
            self=@
#            index=currentTab-1
            tab=@model.tabs[index]
#            @previousDate=false
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
            if(navigator.userAgent.indexOf('Windows NT ')!=-1)
              @triangle.style.transform ="translate3d(#{shift}px, 0, 0)"
            @tabsLinks.removeClass("active");
            index=@model.currentTab-1
            @$('#change-tabs a').eq(index).addClass("active");

          changeTab:(event)=>
           event.preventDefault()
           newTabIndex= event.target.getAttribute('href').substr(1)
           console.log newTabIndex
           @resetTabPosition()
           if(@model.currentTab!=+newTabIndex)
             @model.currentTab=  +newTabIndex
             @showCurrentTab()


          tabTransition:()->
            @shift=(@model.currentTab-1)*100;
            @elTabsDom.style.transitionDuration='300ms'
            @elTabsDom.style.webkitTransform ="translate3d(-#{@shift}%, 0, 0)"
            @ptr.style.webkitTransform ="translate3d(#{@shift}%, 0, 0)"
            if(navigator.userAgent.indexOf('Windows NT ')!=-1)
              @ptr.style.transform ="translate3d(#{@shift}px, 0, 0)"


          resetTabPosition:()->
            tab= @domTabsObj[@model.currentTab-1][0]
            tab.style.transitionDuration='0ms'
            tab.style.webkitTransform="translate3d(0,0,0)"
            @elBody.className=""

          onChangeOrientation:()->
            window.onresize = ()=>
              @tabsLinkWidth = window.innerWidth/@model.tabs.length
              @changePositionTriagle()

        return ListView

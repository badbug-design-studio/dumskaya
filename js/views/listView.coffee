define ['_','baseView','text!templates/lists.html','hammer'],
  (_, BaseView,template,Hammer)->

        class ListView extends BaseView
          template:template
          domTabsObj:[]
          model:
            currentTab:1
            name:"Dumskaya"
            tabs:[
              {id:'tab1',name:'News',onShowComplete:()->
                  renderNews=()->
#                    its hust for test!!!
                    data={}
                    data.items=[{name:'Facebook'},{name:'Twitter'},{name:'Gmail'}]
#                    !!!!
                    baseApplication.currentView.appendCompiledTemplate('templates/news.html',data).bind(this)
                    baseApplication.sync.request('http://google.com').then((data)->
                      renderNews(data)
                    ,(data)=>
                      renderNews(data)
                    )
              }
              {id:'tab2',name:'Blogs',onShowComplete:()->}
              {id:'tab3',name:'Photos',onShowComplete:()->}
              {id:'tab4',name:'Video',onShowComplete:()->}
            ]

          constructor:(query)->
            super


          onRender:()->
            @elTabsDom7=@$('.tabs')
            @elTabs=@$('.tabs')[0]
            @tabsLinkWidth = window.innerWidth/@model.tabs.length
            @handleTabs()
            @swipeTabsHandle()
            @changePositionTriagle()
            index=@model.currentTab-1
            @model.tabs[index].onShowComplete()

          handleTabs:()->
            _.each(@model.tabs,(tab,i)=>
              tabDom=@$('#'+tab.id)
              @domTabsObj.push(tabDom)
              tabDom.on('show',  () =>
                @model.currentTab=(i+1)
                @changePositionTriagle()
                tab.onShowComplete()
              );
            )

          swipeTabsHandle:()->
            Hammer(@elTabsDom7[0]).on("swipeleft", ()=>
              if(@model.currentTab<@model.tabs.length)
                @model.currentTab++
                @showCurrentTab()

            );
            Hammer(@elTabsDom7[0]).on("swiperight", ()=>
              if(@model.currentTab>1)
                 @model.currentTab--
                 @showCurrentTab()
            );
           showCurrentTab:()->
              baseApplication.f7app.showTab('#tab'+@model.currentTab)
              @changePositionTriagle()
              index=@model.currentTab-1
              @model.tabs[index].onShowComplete()


          onPageBeforeAnimation:()->
            console.log("onPageBeforeAnimation")

          changePositionTriagle:()->
            triangle= @$('.buttons-row .triangle')[0]
            shift = @model.currentTab*@tabsLinkWidth - @tabsLinkWidth/2;
            console.log triangle.style.transform = "translate3d(#{shift}px, 0, 0)";


        return ListView

define ['_','baseView','text!templates/lists.html','hammer'],
  (_, BaseView,template,Hammer)->

        class ListView extends BaseView
          template:template
          domTabsObj:{}
          model:
            currentTab:1
            name:"Dumskaya"
            tabs:[
             {id:'tab1',name:'News',onShowComplete:()->}
             {id:'tab2',name:'Blogs',onShowComplete:()->}
             {id:'tab3',name:'Photos',onShowComplete:()->}
             {id:'tab4',name:'Video',onShowComplete:()->}
           ]

          constructor:(query)->
            super


          onRender:()->
            @elTabs=@$('.tabs')[0]
            @handleTabs()
            @swipeTabsHandle()

          handleTabs:()->
            _.each(@model.tabs,(tab,i)=>
              tabDom=@$('#'+tab.id)
              @domTabsObj[tab.id]=tabDom
              tabDom.on('show',  () =>
                @model.currentTab=(i+1)
                @changePositionTriagle()
                tab.onShowComplete()
              );
            )

          swipeTabsHandle:()->
            Hammer(@elTabs).on("swipeleft", ()=>
              if(@model.currentTab<@model.tabs.length)
                @model.currentTab++
                @showCurrentTab()

            );
            Hammer(@elTabs).on("swiperight", ()=>
              if(@model.currentTab>1)
                 @model.currentTab--
                 @showCurrentTab()
            );
           showCurrentTab:()->
              baseApplication.f7app.showTab('#tab'+@model.currentTab)
              index=@model.currentTab-1
              @changePositionTriagle()
              @model.tabs[index].onShowComplete()


          onPageBeforeAnimation:()->
            console.log("onPageBeforeAnimation")

          changePositionTriagle:()->




        return ListView

define ['_','baseView','text!templates/items.html','hammer'],
  (_, BaseView,itemsTemplate, Hammer)->

        class CategoryView extends BaseView
          template:null
          isInjectedOnly:true
          container:()->
              return @model.listView.domTabsObj[@tabIndex]

          constructor:(query)->
            if(query && query.model)
              @model = query.model
              @model.renderList=@renderList
            if(query && query.viewParams)
              @viewParams = query.viewParams

            if(query && typeof query.tabIndex !='undefined')
              @tabIndex=query.tabIndex
            @render()


          initCustomInfinitScroll:()->
             cT=@model.listView.model.currentTab-1
             @loading = false;
             menuHeight=69 #harcode
             preloaderHeightAvg=25 #harcode
             tabHeight=@model.listView.domTabsObj[cT][0].clientHeight
             infinitScrollHeight=@model.listView.domTabsObj[cT][0].firstChild.scrollHeight
#             onrender ===
             if(tabHeight>=infinitScrollHeight)
               @triggerCustomInfiniteScroll(()=>
                                  infinitScrollHeight=@model.listView.domTabsObj[cT][0].firstChild.scrollHeight+5
               )
              #onscroll===
             @model.listView.domTabsObj[cT][0].onscroll=()=>
               if(@model.listView.model.needUpdateScroll) #after pull to refresh
                 infinitScrollHeight=@model.listView.domTabsObj[cT][0].firstChild.scrollHeight
                 @model.listView.model.needUpdateScroll=false

               if(@model.listView.domTabsObj[cT][0].scrollTop+tabHeight-menuHeight-preloaderHeightAvg>=infinitScrollHeight)
                 @triggerCustomInfiniteScroll(()=>
                   infinitScrollHeight=@model.listView.domTabsObj[cT][0].firstChild.scrollHeight
                 )


#             @model.listView.domTabsObj[cT][0].on('infinite',  ()=>
#               @triggerCustomInfiniteScroll()
#             )

          triggerCustomInfiniteScroll:(callback)->
             if (@loading) then return;
     #       Set loading flag
             @loading = true;
             setTimeout(()=>
                @loading=false
                index=@model.cacheKey
                if(!baseApplication.cache.data[index])
                  return
                itemLength=baseApplication.cache.data[index].channel.item.length
                renderedCount=@model.listView.indexes[index]
                if(renderedCount==itemLength-@model.limit)
                    domEl=@infiniteScrollSelector()
                    if(domEl) then domEl.remove()
                    return false
                @model.listView.indexes[index]+=@model.limit
                @appendOldData()
                callback() if callback
             ,1000)





          renderList:()=>
            compile=_.template(itemsTemplate)
            compiledHtml=compile(@model)

            return  compiledHtml

          appendOldData:()->
            compiledTemplate=@renderList()
            @appendEl().append(compiledTemplate)






        return CategoryView

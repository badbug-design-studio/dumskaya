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
             cacheKey=@model.cacheKey
#             alert baseApplication.cache.data[cacheKey].length
#             alert baseApplication.cache.data[cacheKey].length<15
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
                cacheKey=@model.cacheKey
                itemLength=0
                if baseApplication.cache.data[cacheKey]
                  itemLength=baseApplication.cache.data[cacheKey].length
                if(!baseApplication.cache.data[cacheKey]||!itemLength)
                  return
                if @model.listView.indexes[cacheKey]+@model.limit>itemLength
                  count=itemLength-@model.listView.indexes[cacheKey]
                else
                  count=@model.limit
                @model.listView.indexes[cacheKey]+=count
                if(@model.listView.indexes[cacheKey]>=itemLength)
                  baseApplication.cache.getDataFromTable(cacheKey,(data)=>
                    if(data)
                       Array.prototype.push.apply(baseApplication.cache.data[cacheKey], data); #merge arrays
#                         console.log(baseApplication.cache.data[cacheKey])
                       @renderOtherItems(baseApplication.cache.data[cacheKey].length-@model.listView.indexes[cacheKey],callback)
                    else
                     @hideInfinitePreloader()
                  ,itemLength);
                else
                  @renderOtherItems(count,callback)
             ,1000)


          renderOtherItems:(count,callback)->

            cacheKey=@model.cacheKey
            baseApplication.cache.prepareCachedImgsRecursive(@model.listView.indexes[cacheKey],count,baseApplication.cache.data[cacheKey],()=>
              @appendOldData()
              callback() if callback
            )

          hideInfinitePreloader:()->
            domEl=@infiniteScrollSelector()
            if(domEl) then domEl.remove()

          renderList:()=>
            compile=_.template(itemsTemplate)
            compiledHtml=compile(@model)

            return  compiledHtml

          appendOldData:()->
            compiledTemplate=@renderList()
            @appendEl().append(compiledTemplate)






        return CategoryView

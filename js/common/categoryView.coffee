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
             if(baseApplication.cache.data[cacheKey].length>15&&tabHeight>=infinitScrollHeight)
               @triggerCustomInfiniteScroll(()=>
                                  infinitScrollHeight=@model.listView.domTabsObj[cT][0].firstChild.scrollHeight+5
               )
             else
               @hideInfinitePreloader()

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
                alert(2)
                @loading=false
                cacheKey=@model.cacheKey
                itemLength=baseApplication.cache.data[cacheKey].length
                console.log(itemLength)
                if(!baseApplication.cache.data[cacheKey]||!itemLength)
                  return
                if (@model.listView.indexes[cacheKey]+@model.limit)>itemLength
                    increaser=(itemLength-@model.listView.indexes[cacheKey])
                else
                    increaser=@model.limit
                @model.listView.indexes[cacheKey]+=increaser
                console.log(@model.listView.indexes[cacheKey])
                if(@model.listView.indexes[cacheKey]>=itemLength)
                    alert(1)
                    baseApplication.cache.getDataFromTable(cacheKey,(data)=>
#                      console.log(data)
                      if(data&&data.length!=itemLength)
                         console.log('merge arrays')
                         Array.prototype.push.apply(baseApplication.cache.data[cacheKey], data); #merge arrays
#                         console.log(baseApplication.cache.data[cacheKey])
                         @appendOldData()
                         callback() if callback
                      else
                       @hideInfinitePreloader()

                    ,itemLength);
                else
                   @appendOldData()
                   callback() if callback
             ,1000)



          hideInfinitePreloader:()->
            console.log('the end')
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

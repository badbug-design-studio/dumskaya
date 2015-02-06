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
             if(@model.listView.infiniteTabsEventOn[cT])
               return
             @model.listView.infiniteTabsEventOn[cT]=true
             menuHeight=69 #harcode
             preloaderHeightAvg=25 #harcode
             tabHeight=@model.listView.domTabsObj[cT][0].clientHeight
             scrollHeiht=@model.listView.domTabsObj[cT][0].firstChild.scrollHeight
             if(tabHeight>=scrollHeiht)
               @triggerCustomInfiniteScroll()
             @model.listView.domTabsObj[cT][0].onscroll=()=>
               if(@model.listView.domTabsObj[cT][0].scrollTop+tabHeight-menuHeight-preloaderHeightAvg>=scrollHeiht)
                 @triggerCustomInfiniteScroll(()=>
                   scrollHeiht=@model.listView.domTabsObj[cT][0].firstChild.scrollHeight
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
                itemLength=baseApplication.cache.data[index].channel.item.length
                renderedCount=@model.listView.indexes[index]
                if(renderedCount==itemLength-@model.limit)
                    domEl=@infiniteScrollSelector()
                    if(domEl) then domEl.remove()
                    cT=@model.listView.model.currentTab-1
                    @model.listView.domTabsObj[cT][0].onscroll=null
                    return false
                @model.listView.indexes[index]+=@model.limit
                @appendOldData()
                callback() if callback
             ,1000)

          handleOnClickItem:()->
              cT=@model.listView.model.currentTab-1
              self=this
              elem=@model.listView.domTabsObj[cT][0]
              Hammer(elem).on("tap", (event) ->
                  index=event.target.getAttribute('data-index')
                  if(!index)
                    return
                  model=baseApplication.cache.data[self.cacheClass].channel.item[index]
                  model.cacheClass=self.cacheClass
                  model.index=index
                  baseApplication.router.loadPage('oneItem',{model:model})
              );




          renderList:()=>
            compile=_.template(itemsTemplate)
            compiledHtml=compile(@model)

            return  compiledHtml

          appendOldData:()->
            compiledTemplate=@renderList()
            @appendEl().append(compiledTemplate)






        return CategoryView

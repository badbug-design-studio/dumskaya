define ['_','baseView','text!templates/items.html'],
  (_, BaseView,itemsTemplate)->

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


          initInfinitScroll:()->
             cT=@model.listView.model.currentTab-1
             loading = false;
             if(@model.listView.infiniteTabsEventOn[cT])
               return
             @model.listView.infiniteTabsEventOn[cT]=true
             @model.listView.domTabsObj[cT].on('infinite',  ()=>
               if (loading) then return;
       #       Set loading flag
               loading = true;
               setTimeout(()=>
                  loading=false
                  index=@model.cacheKey
                  itemLength=baseApplication.cache.data[index].channel.item.length
                  renderedCount=@model.listView.indexes[index]
                  if(renderedCount==itemLength-@model.limit)
#                       baseApplication.f7app.detachInfiniteScroll(@$('.infinite-scroll'));
                      @infiniteScrollSelector().remove()
                      return false
                  @model.listView.indexes[index]+=@model.limit
                  @appendOldData()
               ,1000)
             )

          handleOnClickItem:()->
            cT=@model.listView.model.currentTab-1
            @model.listView.domTabsObj[cT].on('click',@itemSelector,()=>
              index=@$(event.target).parents('.item-content').data('index')
              model=baseApplication.cache.data[@cacheClass].channel.item[index]
              model.cacheClass=@cacheClass
              model.index=index
              baseApplication.router.loadPage('oneItem',{model:model})
            )


          renderList:()=>
            compile=_.template(itemsTemplate)
            compiledHtml=compile(@model)

            return  compiledHtml

          appendOldData:()->
            compiledTemplate=@renderList()
            @appendEl().append(compiledTemplate)






        return CategoryView

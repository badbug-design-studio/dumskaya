define ['_','baseView'],
  (_, BaseView)->

        class CategoryView extends BaseView
          template:null
          isInjectedOnly:true
          container:()->
              console.log @index
              return @model.listView.domTabsObj[@index]

          constructor:(query)->
            if(query && query.model)
              @model = query.model
            if(query && query.viewParams)
              @viewParams = query.viewParams

            if(query && typeof query.index !='undefined')
              @index=query.index
            @render()


          initInfinitScroll:()->
             cT=@model.listView.model.currentTab-1
             loading = false;
             if(@model.listView.infiniteTabsEventOn[cT])
               return
             @model.listView.infiniteTabsEventOn[cT]=true
             @model.listView.domTabsObj[cT].on('infinite',  ()=>
               if (loading) then return;
               @infiniteStart()
       #              // Set loading flag
               loading = true;
               setTimeout(()->
                 loading=false
               ,1000)
             )

          handleOnClickItem:()->
            cT=@model.listView.model.currentTab-1
            @model.listView.domTabsObj[cT].on('click',@itemSelector,()=>
              index=@$(event.target).parents('.item-content').data('index')
              baseApplication.router.loadPage('oneItem',{model:baseApplication.cache.items[@cacheClass][index]})
            )







        return CategoryView

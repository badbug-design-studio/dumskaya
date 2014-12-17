define ['_','baseView'],
  (_, BaseView)->

        class CategoryView extends BaseView
          template:null
          isAppendOnly:true

          constructor:(query)->
            if(query && query.model)
              @model = query.model
            if(query && query.viewParams)
              @viewParams = query.viewParams
            @container=()=>
              ct= @model.listView.model.currentTab
              return @model.listView.domTabsObj[ct-1]
            @render()





        return CategoryView

define([
    'f7'
],  () ->
      tabs= [
                    {id:'tab1',name:'Новости',updateItems:(pullToRefreshCallback)->
                        onDownloaded=(data)=>
                          result={}
                          result.items=data.channel.item
                          @appendCompiledTemplate('templates/news.html',result)

                        baseApplication.cache.getNews(onDownloaded, pullToRefreshCallback)
                    }
                    {id:'tab2',name:'Блоги',updateItems:()->}
                    {id:'tab3',name:'ТВ',updateItems:()->}
                    {id:'tab4',name:'Статьи',updateItems:()->}
      ]
      return tabs
);

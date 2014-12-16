define([
    'f7'
],  () ->
      tabs= [
                    {id:'tab1',name:'News',updateItems:(pullToRefreshCallback)->
                        console.log arguments
                        console.log pullToRefreshCallback
                        onDownloaded=(data)=>
                          result={}
                          result.items=data.channel.item
                          @appendCompiledTemplate('templates/news.html',result)

                        baseApplication.cache.getNews(onDownloaded, pullToRefreshCallback)
                    }
                    {id:'tab2',name:'Blogs',updateItems:()->}
                    {id:'tab3',name:'Photos',updateItems:()->}
                    {id:'tab4',name:'Video',updateItems:()->}
      ]
      return tabs
);

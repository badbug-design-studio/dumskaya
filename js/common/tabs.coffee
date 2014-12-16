define([
    'f7'
],  () ->
      tabs= [
                    {id:'tab1',name:'Новости',updateItems:(pullToRefreshCallback)->
                        onDownloaded=(data)=>
                          result={}
                          result.items=data.channel.item
                          result.limit=10
                          @appendCompiledTemplate('templates/news.html',result)
                        console.log baseApplication.cache.items
                        if(!pullToRefreshCallback&&typeof baseApplication.cache.items.news!='undefined')
                          return
                        baseApplication.cache.getNews(onDownloaded, pullToRefreshCallback)
                    }
                    {id:'tab2',name:'Блоги',updateItems:(pullToRefreshCallback)->
                      onDownloaded=(data)=>
                          console.log data
                          result={}
                          result.items=data.channel.item
                          result.limit=10
                          @appendCompiledTemplate('templates/blogs.html',result)
                      if(!pullToRefreshCallback&&typeof baseApplication.cache.items.blogs!='undefined')
                        return
                      baseApplication.cache.getBlogs(onDownloaded, pullToRefreshCallback)
                    }
                    {id:'tab3',name:'ТВ',updateItems:(pullToRefreshCallback)->
                      onDownloaded=(data)=>
                           console.log data
                           result={}
                           result.items=data.channel.item
                           result.limit=10
                           @appendCompiledTemplate('templates/tv.html',result)
                      if(!pullToRefreshCallback&&typeof baseApplication.cache.items.tv!='undefined')
                       return
                      baseApplication.cache.getTV(onDownloaded, pullToRefreshCallback)
                    }
                    {id:'tab4',name:'Статьи',updateItems:()->}
      ]
      return tabs
);

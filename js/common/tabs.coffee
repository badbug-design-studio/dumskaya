define([
    'f7','views/newsView','views/blogsView','views/tvView'
],  (f7,NewsView,BlogsView,TVView) ->
      tabs= [
                    {id:'tab1',name:'Новости',updateItems:(pullToRefreshCallback)->
                      onDownloaded=(data,cacheKey)=>
                              model={}
                              model.items=[]
                              if data&&data.channel&&data.channel.item
                                model.items=data.channel.item
                              model.limit=15
                              @indexes[cacheKey]=0
                              model.listView=@
                              model.cacheKey=cacheKey

                              new NewsView({model:model,tabIndex:0})

                      baseApplication.cache.getList('news',onDownloaded, pullToRefreshCallback)
                    }
                    {id:'tab2',name:'Блоги',updateItems:(pullToRefreshCallback)->
                      onDownloaded=(data,cacheKey)=>
                            model={}
                            model.items=[]
                            if data&&data.channel&&data.channel.item
                              model.items=data.channel.item
                            model.limit=15
                            @indexes[cacheKey]=0
                            model.listView=@
                            model.cacheKey=cacheKey
                            new BlogsView({model:model,tabIndex:1})

                      baseApplication.cache.getList('blogs',onDownloaded, pullToRefreshCallback)
                    }
                    {id:'tab3',name:'ТВ',updateItems:(pullToRefreshCallback)->
                      onDownloaded=(data,cacheKey)=>
                           model={}
                           model.items=[]
                           if data&&data.channel&&data.channel.item
                             model.items=data.channel.item
                           model.limit=15
                           @indexes[cacheKey]=0
                           model.listView=@
                           model.cacheKey=cacheKey
                           new TVView({model:model,tabIndex:2})

                      baseApplication.cache.getList('tv',onDownloaded, pullToRefreshCallback)
                    }
#                    {id:'tab4',name:'Статьи',updateItems:(pullToRefreshCallback)->
#                      onDownloaded=(data,cacheKey)=>
#                        model={}
#                        model.items=[]
#                        if data&&data.channel&&data.channel.item
#                          model.items=data.channel.item
#                        model.limit=10
#                        @indexes[cacheKey]=0
#                        model.listView=@
#                        model.cacheKey=cacheKey
#                        new ArticlesView({model:model,tabIndex:2})
#
#                      baseApplication.cache.getList('articles',onDownloaded, pullToRefreshCallback)
#                    }
      ]
      return tabs
);

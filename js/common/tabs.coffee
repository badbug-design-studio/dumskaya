define([
    'f7','views/newsView','views/blogsView','views/tvView'
],  (f7,NewsView,BlogsView,TVView) ->
      tabs= [
                    {id:'tab1',name:'Новости',updateItems:(pullToRefreshCallback)->
                      onDownloaded=(data)=>
                              model={}
                              model.items=data.channel.item
                              model.limit=10
                              model.listView=@
                              new NewsView({model:model})

                      if(!pullToRefreshCallback&&typeof baseApplication.cache.items.news!='undefined')
                          return
                      baseApplication.cache.getNews(onDownloaded, pullToRefreshCallback)
                    }
                    {id:'tab2',name:'Блоги',updateItems:(pullToRefreshCallback)->
                      onDownloaded=(data)=>
                            model={}
                            model.items=data.channel.item
                            model.limit=10
                            model.listView=@
                            new BlogsView({model:model})

                      if(!pullToRefreshCallback&&typeof baseApplication.cache.items.blogs!='undefined')
                        return
                      baseApplication.cache.getBlogs(onDownloaded, pullToRefreshCallback)
                    }
                    {id:'tab3',name:'ТВ',updateItems:(pullToRefreshCallback)->
                      onDownloaded=(data)=>
                           model={}
                           model.items=data.channel.item
                           model.limit=10
                           model.listView=@
                           new TVView({model:model})

                      if(!pullToRefreshCallback&&typeof baseApplication.cache.items.tv!='undefined')
                       return
                      baseApplication.cache.getTV(onDownloaded, pullToRefreshCallback)
                    }
                    {id:'tab4',name:'Статьи',updateItems:()->}
      ]
      return tabs
);

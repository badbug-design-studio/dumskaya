define([
    'f7','views/newsView','views/blogsView','views/tvView'
],  (f7,NewsView,BlogsView,TVView) ->
      tabs= [
                    {id:'tab1',name:'Новости',updateItems:(pullToRefreshCallback)->
                      onDownloaded=(data)=>
                              model={}
                              model.items=[]

                              if data&&data.channel&&data.channel.item
                                model.items=data.channel.item
                              model.limit=10
                              model.listView=@
                              new NewsView({model:model,index:0})

                      baseApplication.cache.getList('news',onDownloaded, pullToRefreshCallback)
                    }
                    {id:'tab2',name:'Блоги',updateItems:(pullToRefreshCallback)->
                      onDownloaded=(data)=>
                            model={}
                            model.items=[]
                            if data&&data.channel&&data.channel.item
                              model.items=data.channel.item
                            model.limit=10
                            model.listView=@
                            new BlogsView({model:model,index:1})

                      baseApplication.cache.getList('blogs',onDownloaded, pullToRefreshCallback)
                    }
                    {id:'tab3',name:'ТВ',updateItems:(pullToRefreshCallback)->
                      onDownloaded=(data)=>
                           model={}
                           model.items=[]
                           if data&&data.channel&&data.channel.item
                             model.items=data.channel.item
                           model.limit=10
                           model.listView=@
                           new TVView({model:model,index:2})

                      baseApplication.cache.getList('tv',onDownloaded, pullToRefreshCallback)
                    }
                    {id:'tab4',name:'Статьи',updateItems:()->}
      ]
      return tabs
);

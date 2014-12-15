define([
    'f7'
],  () ->
      tabs= [
                    {id:'tab1',name:'News',onShowComplete:()->
                        renderNews=(data)->
                          result={}
                          result.items=data.channel.item
                          console.log(data)
                          baseApplication.currentView.appendCompiledTemplate('templates/news.html',result)


                        baseApplication.sync.request(baseApplication.sync.getNewsRssUrl(),true,(data)->
                            alert('promise true')
                            renderNews(data)
                          ,(data)=>
                            alert('promise false')
                            renderNews(data)
                          )
                    }
                    {id:'tab2',name:'Blogs',onShowComplete:()->}
                    {id:'tab3',name:'Photos',onShowComplete:()->}
                    {id:'tab4',name:'Video',onShowComplete:()->}
      ]
      return tabs
);

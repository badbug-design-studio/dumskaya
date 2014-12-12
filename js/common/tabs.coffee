define([
    'f7'
],  () ->
      tabs= [
                    {id:'tab1',name:'News',onShowComplete:()->
                        renderNews=(data)->
      #                    its hust for test!!!
                          data={}
                          data.items=[{name:'Facebook'},{name:'Twitter'},{name:'Gmail'}]
                          baseApplication.currentView.appendCompiledTemplate('templates/news.html',data)


                        baseApplication.sync.request('http://google.com').then((data)->
                            renderNews(data)
                          ,(data)=>
                            renderNews(data)
                          )
                    }
                    {id:'tab2',name:'Blogs',onShowComplete:()->}
                    {id:'tab3',name:'Photos',onShowComplete:()->}
                    {id:'tab4',name:'Video',onShowComplete:()->}
      ]
      return tabs
);

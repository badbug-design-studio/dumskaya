define ['f7','_'],
(Framework7,_)->
  class Cache
    $: Framework7.$
    date:new Date()
    items:{}
    getNews:(callback,pullToRefreshCallback)->
      delay=0
      delay=1000 if pullToRefreshCallback
      baseApplication.sync.request(baseApplication.sync.getNewsRssUrl(),true,(data)=>
        if(!@items.news||(@items.news.length!=data.channel.item.length))
          @items.news=data.channel.item
          setTimeout(()->
            callback(data)
            pullToRefreshCallback() if pullToRefreshCallback
          ,delay)
        else
          setTimeout(()->
                     pullToRefreshCallback() if pullToRefreshCallback
          ,delay)
      )

  return Cache


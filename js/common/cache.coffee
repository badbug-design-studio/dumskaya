define ['f7','_'],
(Framework7,_)->
  class Cache
    $: Framework7.$
    date:new Date()
    items:{}
    dbName:"dumskayaDB"
    constructor:(callback)->
      callback()
      #@initCache(callback)

    getList:(cacheKey,callback,need2Update)->
      if(!need2Update&&typeof @items[cacheKey]!='undefined')
            return
      delay=0
      delay=1000 if need2Update
      cachedData=@getCachedData(cacheKey)
      if(cachedData)#if we had cache work wit it
        setTimeout(()->
          callback(cachedData)
          pullToRefreshCallback() if need2Update
        ,delay)
        return false #dont do any request

      url=@getUrl(cacheKey)
      baseApplication.sync.request(url,true,(data)=>
        if(!@items[cacheKey]||(@items[cacheKey].length!=data.channel.item.length))
          @items[cacheKey]=data.channel.item
          setTimeout(()->
            callback(data)
            need2Update() if need2Update
          ,delay)
        else
          setTimeout(()->
            need2Update() if need2Update
          ,delay)
    )

    getUrl:(cacheKey)->
      switch cacheKey
        when "news" then return baseApplication.sync.getNewsRssUrl()
        when "blogs" then return baseApplication.sync.getBlogsRssUrl()
        when "tv" then return baseApplication.sync.getTVRssUrl()
        else console.error('URL not found by key')


    getCompiledHtml:(key,template,model)->
#      console.log key
#      console.log template
#      console.log model
#      console.log '----------------'
      cachedHtml=@getCachedHtml(key)
      if cachedHtml
        compiledHtml=cachedHtml
      else
        compile=_.template(template)
        compiledHtml=compile(model)
      return compiledHtml

    getCachedHtml:(cacheKey)->
      return false

    getCachedData:(cacheKey,callback)->
      return false
      transaction = @db.transaction(['data'], 'readwrite');
      store = transaction.objectStore('data');
      request = store.get(cacheKey);
      request.onsuccess=(e)->
        console.log event.target.result
        callback if callback

      request.onerror = @databaseError;
      return false

    setCachedData:(cacheKey,data,callback)->
      transaction = @db.transaction(['data'], 'readwrite');
      store = transaction.objectStore('data');
      request = store.put({
        data: data,
        id: cacheKey
      });
      request.onsuccess=(e)->
        callback if callback

      request.onerror = @databaseError;

    setCachedHtml:(cacheKey,data)->

    initCache:(callback)->
      version = 1;
      request = indexedDB.open(@dbName, version);
      request.onupgradeneeded = (e) =>
         @db = e.target.result;
         e.target.transaction.onerror = @databaseError;
         @db.createObjectStore('data', { keyPath: 'id' });

      request.onsuccess = (e)=>
        @db = e.target.result;
#        @setCachedData('news','test')
        callback() if callback

      request.onerror = @databaseError;

    databaseError:(e)->
      console.error('An IndexedDB error has occurred', e);


  return Cache


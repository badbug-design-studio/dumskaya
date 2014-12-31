define ['f7','_'],
(Framework7,_)->
  class Cache
    $: Framework7.$
    date:new Date()
    items:{}
    dbName:"dumskayaDB"
    tableName: null
    tableData: null
    db: null
    constructor:(callback)->
      callback()
      #@initCache(callback)
      @initDatabase()

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
      @tableName = cacheKey
      baseApplication.sync.request(url,true,(data)=>
        if(!@items[cacheKey]||(@items[cacheKey].length!=data.channel.item.length))
          @items[cacheKey]=data.channel.item
          @tableData=data.channel.item
          @setTableData()
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

    initDatabase: () ->
      dbName = 'dumskaya';
      version = '1.0';
      displayName = 'Web SQL Storage Dumskaya Database';
      maxSize = 20*1024*1024;
      if window.openDatabase
        @db = openDatabase(dbName, version, displayName, maxSize);
        @db.transaction(@createDbTables, @errorHandler);
      else
        console.error("It seems your browser does not have support for WebSQL.")

    createDbTables:(tx)=>
      tx.executeSql("CREATE TABLE IF NOT EXISTS news (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, data TEXT, created REAL)", [], null, @errorHandler)
      tx.executeSql("CREATE TABLE IF NOT EXISTS blogs (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, data TEXT, created REAL)", [], null, @errorHandler)
      tx.executeSql("CREATE TABLE IF NOT EXISTS tv (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, data TEXT, created REAL)", [], null, @errorHandler)
      tx.executeSql("CREATE TABLE IF NOT EXISTS articles (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, data TEXT, created REAL)", [], null, @errorHandler)

    errorHandler: (error)->
      console.error(error)
      return false;

    setTableData: ()=>
      @db.transaction((tx)=>
        tx.executeSql("INSERT INTO #{@tableName} (data, created) VALUES (?,?)", [ JSON.stringify(@tableData),  new Date().getTime()]
          (tx, resultSet) ->
            if (!resultSet.rowsAffected)
              alert('No rows affected!');
              return false;
        )
      ,@errorHandler, @getDataFromTable()
      );

    getDataFromTable: () =>
      @db.transaction((tx)=>
        tx.executeSql("SELECT * FROM #{@tableName}", [], (tx,result)->
          for item in [0...result.rows.length]
            news = result.rows.item(item);
            console.info(news)
        ,@errorHandler, @querySuccess())
      )

    querySuccess: () =>
      console.log true

    dropTables: () =>
      @db.transaction((tx) =>
        tx.executeSql("DROP TABLE #{@tableName}",[],(tx,results)->
          console.log("Successfully Dropped")
        );
      )

  return Cache


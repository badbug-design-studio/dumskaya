define ['f7','_'],
(Framework7,_)->
  class Cache
    $: Framework7.$
    date:new Date()
    items:{}
    dbName:"dumskayaDB"
    version: '1.0';
    i:0
    db: null
    constructor:(callback)->
      @initDatabase(callback)

    getList:(cacheKey,callback,need2Update)->
      delay=0
      delay=1000 if need2Update
      @getDataFromTable(cacheKey,(cachedData)=>
        if(cachedData&&!need2Update)#if we had cache work wit it
          setTimeout(()=>
            if !@items[cacheKey]
              parsedData=JSON.parse(cachedData.data)
              @items[cacheKey]=parsedData.channel.item
              callback(parsedData)
            need2Update() if need2Update
          ,delay)
          return false #dont do any request

        url=@getUrl(cacheKey)
        baseApplication.sync.request(url,true,(data)=>
          if(data&&data.channel) #set new info if we got it from server
            @items[cacheKey]=data.channel.item
            @setTableData(cacheKey,data)

          setTimeout(()->
            if data&&data.channel #do rerender only if we got new info
              callback(data)
            else if !cachedData #if we dont have new data and cached info for current tab do render anywhere,because we must show something
              callback(data)
            need2Update() if need2Update
          ,delay)
        )
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


    databaseError:(e)->
      console.error('An IndexedDB error has occurred', e);

    initDatabase: (callback) ->
      displayName = 'Web SQL Storage Dumskaya Database';
      maxSize = 20*1024*1024;
      if window.openDatabase
        @db = openDatabase(@dbName, @version, displayName, maxSize);
        @db.transaction(@createDbTables, @errorHandler);
        callback()
      else
        callback()
        console.error("It seems your browser does not have support for WebSQL.")

    createDbTables:(tx)=>
      tx.executeSql("CREATE TABLE IF NOT EXISTS news (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, data TEXT, created REAL)", [], null, @errorHandler)
      tx.executeSql("CREATE TABLE IF NOT EXISTS blogs (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, data TEXT, created REAL)", [], null, @errorHandler)
      tx.executeSql("CREATE TABLE IF NOT EXISTS tv (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, data TEXT, created REAL)", [], null, @errorHandler)
      tx.executeSql("CREATE TABLE IF NOT EXISTS articles (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, data TEXT, created REAL)", [], null, @errorHandler)
#      tx.executeSql("CREATE UNIQUE INDEX myindex ON news (id, data, JOB);", [], null, @errorHandler)

    errorHandler: (error)->
      console.error(error)
      return false;

    setTableData: (tableName, data)=>
      @db.transaction((tx)=>
        tx.executeSql("INSERT OR REPLACE INTO #{tableName} (id,data, created) VALUES (?,?,?)", [1,JSON.stringify(data),  new Date().getTime()]
          (tx, resultSet) ->
            if (!resultSet.rowsAffected)
              alert('No rows affected!');
              return false;
        )
      ,@errorHandler, ()->console.log('set to db-success!')
      );

    getDataFromTable: (tableName,callback) =>
      @db.transaction((tx)=>
        tx.executeSql("SELECT * FROM #{tableName}", [], (tx,result)->
          if result.rows.length
            data = result.rows.item(0);
          else data=false
          callback(data)
        ,@errorHandler, @querySuccess())
      )

    querySuccess: () =>
      console.log true

    dropTables: (tableName) =>
      @db.transaction((tx) =>
        tx.executeSql("DROP TABLE #{tableName}",[],(tx,results)->
          console.log("Successfully Dropped")
        );
      )

  return Cache


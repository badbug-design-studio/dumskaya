define ['f7','_'],
(Framework7,_)->
  class Cache
    $: Framework7.$
    date:new Date()
    data:{}
    dbName:"dumskayaDB"
    version: '1.0';
    db: null
    constructor:(callback)->
      @initDatabase(callback)

    getList:(cacheKey,callback,need2Update)->
      delay=0
      delay=1300 if need2Update
      @need2Update=need2Update
      @listViewCallback=callback
      @cachedTableName=cacheKey
      if @error
        @requestDo(false)
        return
      @getDataFromTable(cacheKey,(cachedData)=>
        if(cachedData&&!need2Update)#if we had cache work wit it
          setTimeout(()=>
            if !@data[cacheKey]
              parsedData=JSON.parse(cachedData.data)
              @data[cacheKey]=parsedData
              callback(parsedData,cacheKey)
            need2Update() if need2Update
          ,delay)
          return false #dont do any request

        @requestDo(cachedData)
      )

    requestDo:(cachedData)->
      delay=0
      delay=1300 if @need2Update
      url=@getUrl(@cachedTableName)
      baseApplication.sync.request(url,true,(data)=>
        if(data&&data.channel) #if we got info from the server
          if !@data[@cachedTableName]||@data[@cachedTableName]&&@data[@cachedTableName].channel.item[0].lastUpdate!=data.channel.item[0].lastUpdate #if we got NEW info
            @setTableData(@cachedTableName,data)
            @data[@cachedTableName]=data


        setTimeout(()=>
          if !cachedData||@need2Update #do render when first time app was started or need to update
            @listViewCallback(@data[@cachedTableName],@cachedTableName)

          @need2Update() if @need2Update
        ,delay)
      )

    getUrl:(cacheKey)->
      switch cacheKey
        when "news" then return baseApplication.sync.getNewsRssUrl()
        when "blogs" then return baseApplication.sync.getBlogsRssUrl()
        when "tv" then return baseApplication.sync.getTVRssUrl()
        when "articles" then return baseApplication.sync.getArticlesRssUrl()
        else console.error('URL not found by key')


    getCompiledHtml:(key,template,model)->
      cachedHtml=@getCachedHtml(key) #on the future
      if cachedHtml
        compiledHtml=cachedHtml
      else
        compile=_.template(template)
        compiledHtml=compile(model)
      return compiledHtml

#    @TODO
    getCachedHtml:(cacheKey)->
      return false




      request.onerror = @databaseError;

#    @TODO
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
        @error=true
        callback()
        console.error("It seems your browser does not have support for WebSQL.")

    createDbTables:(tx)=>
      tx.executeSql("CREATE TABLE IF NOT EXISTS news (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, data TEXT, created REAL)", [], null, @errorHandler)
      tx.executeSql("CREATE TABLE IF NOT EXISTS blogs (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, data TEXT, created REAL)", [], null, @errorHandler)
      tx.executeSql("CREATE TABLE IF NOT EXISTS tv (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, data TEXT, created REAL)", [], null, @errorHandler)
      tx.executeSql("CREATE TABLE IF NOT EXISTS articles (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, data TEXT, created REAL)", [], null, @errorHandler)
#      tx.executeSql("CREATE UNIQUE INDEX myindex ON news (id, data, JOB);", [], null, @errorHandler)

    errorHandler: (error)->
      @error=true
      console.error(error)
      return false;

    setTableData: (tableName, data)=>
      if !@db
        @error = true
        return
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
        ,()->
          console.error('select db error')
          @requstDo(false)
        , @querySuccess())
      )

    querySuccess: () =>
#      console.log true

    dropTables: (tableName) =>
      @db.transaction((tx) =>
        tx.executeSql("DROP TABLE #{tableName}",[],(tx,results)->
          console.log("Successfully Dropped")
        );
      )

  return Cache


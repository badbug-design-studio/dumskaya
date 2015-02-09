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
      @getDataFromTable(cacheKey,(cachedData)=>
        if(cachedData&&!need2Update)#if we had cache work wit it
          setTimeout(()=>
            if !@data[cacheKey] #do render only when we go to the tab first time
              parsedData=JSON.parse(cachedData.data)
              @data[cacheKey]=parsedData
              callback(parsedData,cacheKey)
            else
              console.log 'dont do rerender!'
              console.log cachedData
              console.log need2Update
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




    initDatabase: (callback,reinit) ->
      reinit=reinit||false
      displayName = 'Web SQL Storage Dumskaya Database';
      maxSize = 20*1024*1024;
      if window.openDatabase
        @db = openDatabase(@dbName, @version, displayName, maxSize);
        @db.transaction(@createDbTables, @errorHandler);
        callback() if callback
      else
        console.error("It seems your browser does not have support for WebSQL.")
        callback() if callback


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
      if !@db
        console.error 'set to DB #{tableName} failed'
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
      if !@db
        console.error 'get from DB #{tableName} failed'
        @requestDo(false)
        return

      @db.transaction((tx)=>
        tx.executeSql("SELECT * FROM #{tableName}", [], (tx,result)->
          if result.rows.length
            data = result.rows.item(0);
          else data=false
          callback(data)
        ,(error)=>
          console.error('select db error')
          console.error(error)
          @requestDo(false)
        , @querySuccess(tableName))
      ,(error)=>
        console.error('transaction')
        console.error(error)
        if !error.code
         @initDatabase(()=>
          @requestDo(false)
         )

      )

    querySuccess: (tableName) =>
      console.log "select from db #{tableName} success"

    dropTables: (tableName) =>
      @db.transaction((tx) =>
        tx.executeSql("DROP TABLE #{tableName}",[],(tx,results)->
          console.log("Successfully Dropped")
        );
      )

  return Cache


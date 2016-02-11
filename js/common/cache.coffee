define ['f7','_','imgCache'],
(Framework7,_,ImgCache)->
  class Cache
    $: Framework7.$
    date:new Date()
    dbName:"dumskayaDB"
    version: '1.0';
    db: null
    criteria:"pubDate" #creteria field on what check for add new items
    itemsMaxCount:40
    progressFlag:{}
    updated:{}
    constructor:(onDBinit)->
      @data={}
      @initImgCache(()=>
        @initDatabase(onDBinit)
      )

    initImgCache:(callback)->
      if(typeof cordova=='undefined')
         callback()
         return
      #write log to console
      ImgCache.options.debug = false;

      # increase allocated space on Chrome to 50MB, default was 10MB
      ImgCache.options.chromeQuota = 40*1024*1024;
      ImgCache.options.localCacheFolder = 'dumskaya';
      ImgCache.options.cacheClearSize = 40
      ImgCache.init(()->
          console.log('ImgCache init: success!');
          callback()
          # from within this function you're now able to call other ImgCache methods
          # or you can wait for the ImgCacheReady event

      , ()->
          console.log('ImgCache init: error! Check the log for errors');
          callback()
      )

    getList:(cacheKey,callback,need2Update)->
      @need2Update=need2Update
      @listViewCallback=callback
      @cachedTableName=cacheKey
      if (@data[cacheKey]&&!need2Update) then return @data[cacheKey]#if just run beetween rendered tabs
      if need2Update #if pull to refresh do refresh immediately
        @requestDo()
      else
        console.log('%c GET FROM DB! ', 'background: #222; color: #bada55');
        @getSavedInfo()
#        setTimeout(()=>
#          @requestDo()
#        ,1000)

    getSavedInfo:()->
#      delay=0
#      delay=1300 if @need2Update
      @getDataFromTable(@cachedTableName,(cachedData)=>
#         console.log(cachedData)
         if(cachedData&&cachedData.length)#if we had cache work witt it
             @data[@cachedTableName]=cachedData
             @listViewCallback(cachedData,@cachedTableName)
             @need2Update() if @need2Update
             setTimeout(()=>
               if(!@updated[@cachedTableName])
                @updated[@cachedTableName]=true
                @requestDo(@cachedTableName)
             ,1000)
         else
           @requestDo()
      )
    requestDo:(key)->
      url=@getUrl(@cachedTableName)
      tableKey=key||@cachedTableName
      console.log(tableKey)
      callTab=baseApplication.listView.cacheClassesArr[baseApplication.listView.model.currentTab-1]
      console.log('%c REQUEST! ', 'background: #222; color: #bada55');
      baseApplication.sync.request(url,true,(data)=>
        if(data&&data.channel) #if we got info from the server
            @setTableData(tableKey,data.channel.item,(newSavedItemsCount)=>
              @progressFlag[tableKey]=false
              #callback will call only if something new added to db
#              console.log(callTab)
#              console.log(tableKey)
              if (newSavedItemsCount&&callTab==@cachedTableName)||@need2Update
                @getSavedInfo()
            )
        else #if we dont have information from internet
            if @need2Update
              setTimeout(()=>
                @need2Update() #just close pull ro refresh
              ,1000)
            else
              @listViewCallback(false,tableKey) if !key #just render witout data :(
      )

    getUrl:(cacheKey)->
      switch cacheKey
        when "news" then return baseApplication.sync.getNewsRssUrl()
        when "blogs" then return baseApplication.sync.getBlogsRssUrl()
        when "tv" then return baseApplication.sync.getTVRssUrl()
        when "sport" then return baseApplication.sync.getSportRssUrl()
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
      tx.executeSql("CREATE TABLE IF NOT EXISTS news (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, title TEXT,description TEXT,shortDescription TEXT, lastUpdate REAL, pubDate REAL , smallImg Text, commentscount INTEGER,commentscounturl TEXT,comments TEXT,visited BOOL,link TEXT, created REAL)", [], ()->
        console.log('table created')
      , @errorHandler)
      tx.executeSql("CREATE TABLE IF NOT EXISTS blogs (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, title TEXT,description TEXT,shortDescription TEXT, lastUpdate REAL, pubDate REAL , smallImg Text, commentscount INTEGER,commentscounturl TEXT,comments TEXT,visited BOOL,link TEXT,created REAL)", [], ()->
          console.log('table created')
        , @errorHandler)
      tx.executeSql("CREATE TABLE IF NOT EXISTS tv (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, title TEXT,description TEXT,shortDescription TEXT, lastUpdate REAL, pubDate REAL , smallImg Text, commentscount INTEGER,commentscounturl TEXT,comments TEXT,visited BOOL,link TEXT,created REAL)", [], ()->
          console.log('table created')
        , @errorHandler)
      tx.executeSql("CREATE TABLE IF NOT EXISTS sport (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, title TEXT,description TEXT,shortDescription TEXT, lastUpdate REAL, pubDate REAL , smallImg Text, commentscount INTEGER,commentscounturl TEXT,comments TEXT,visited BOOL,link TEXT,created REAL)", [], ()->
        console.log('table created')
      , @errorHandler)
#      tx.executeSql("CREATE TABLE IF NOT EXISTS articles (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, data TEXT, created REAL)", [], null, @errorHandler)
#      tx.executeSql("CREATE UNIQUE INDEX myindex ON news (id, data, JOB);", [], null, @errorHandler)

    errorHandler: (error)->
      console.error(error)
      return false;

    setTableData: (tableName, data,onSaved)=>
      if !@db
        console.error 'set to DB #{tableName} failed'
        return
      if(@progressFlag[tableName]) #saving in progress!
        return
      @getLastCriteriaUpdate(tableName,(lastFreshNewsCriteriaValue)=>
        @addEachItemsToDbRecursive(tableName,(data.length-1),0,data,lastFreshNewsCriteriaValue,onSaved) #data.length-1 - first save item index. We're saving to db from old to the latest
      )

    updateTableData:(tableName,id,column,value)->
      @db.transaction((tx)=>
            sql="UPDATE #{tableName} SET #{column}=#{value} WHERE id=#{id}"
            tx.executeSql(sql, [], (tx,result)=>
              console.log('update ok')
            ,(err)->
              console.log(err)
            )
      )


    getLastCriteriaUpdate:(tableName,callback)=>
      @progressFlag[tableName]=true
      @db.transaction((tx)=>
#              console.log(tableName)
              sql="SELECT #{this.criteria} FROM #{tableName} order by #{this.criteria} desc limit 1"
#              console.log(sql)
              tx.executeSql(sql, [], (tx,result)=>
                lastFreshNewsCriteriaValue=false
                if(result.rows.length)
                  row=result.rows.item(0)
                  if(row&&row.hasOwnProperty(this.criteria))
                    lastFreshNewsCriteriaValue=row[this.criteria]
                if callback then  callback(lastFreshNewsCriteriaValue)
              ,(err)->
                console.log(err)
              )
      )

    addEachItemsToDbRecursive:(tableName,index,savedItemsCount,itemsArray,freshNewsCriteriaValue,onSaved)->
     if index<0
       onSaved(savedItemsCount)
       return
     oneItem=itemsArray[index]
     newItemCriteriaFromServer=new Date(oneItem[this.criteria]).getTime()
     if(!freshNewsCriteriaValue||freshNewsCriteriaValue&&newItemCriteriaFromServer>freshNewsCriteriaValue) #add in bd only if new items have bigger createTime then the newest in db
#       console.info('add')
       savedItemsCount++
       @addOneItemToDb(tableName,oneItem,()=>
             --index;
             @addEachItemsToDbRecursive(tableName,index,savedItemsCount,itemsArray,newItemCriteriaFromServer,onSaved)
       )
     else
        @updatePreviousRSSItems(tableName,oneItem,()=>
#           console.warn('no add')
           --index;
           @addEachItemsToDbRecursive(tableName,index,savedItemsCount,itemsArray,freshNewsCriteriaValue,onSaved)
        )

    updatePreviousRSSItems:(tableName,itemFromServer,callback)=>
#      console.warn('updating...')
      @db.transaction((tx)=>
        sql="UPDATE  #{tableName} SET title=?, description=?, lastUpdate=?, smallImg=?, commentscount=?,commentscounturl=?, link=?  WHERE pubDate=?"
        tx.executeSql(sql, [itemFromServer.title,JSON.stringify(itemFromServer.description), itemFromServer.lastUpdate, itemFromServer.smallImg, itemFromServer.commentscount,itemFromServer.commentscounturl,itemFromServer.link, parseInt(itemFromServer.createdUnix+"000")]
                (tx, resultSet) ->
                  if (!resultSet.rowsAffected)
#                    alert('No rows affected!');
                    console.error('No rows affected!');
                    return false;
        )
      ,@errorHandler,
        ()->
        if(callback) then callback()
      );

    addOneItemToDb:(tableName,oneItem,callback)->
      @db.transaction((tx)=>
         lastUpdate=+oneItem.lastUpdate||+oneItem.lastupdate #server bug!
         tx.executeSql("INSERT OR REPLACE INTO #{tableName} (title,description,shortDescription,lastUpdate,pubDate,smallImg,commentscount,commentscounturl,comments, link,created) VALUES (?,?,?,?,?,?,?,?,?,?,?)", [oneItem.title,JSON.stringify(oneItem.description),oneItem.shortDescription,lastUpdate,parseInt(oneItem.createdUnix+"000"),oneItem.smallImg,+oneItem.commentscount,oneItem.commentscounturl,oneItem.comments, oneItem.link,new Date().getTime()]
           (tx, resultSet) ->
             if (!resultSet.rowsAffected)
#               alert('No rows affected!');
               console.error('No rows affected!');
               return false;
         )
       ,@errorHandler,
       ()=>
#          console.log('set to db success!')
          if(callback) then callback()
       );

    getDataFromTable: (tableName,callback,startLimit) =>
      if !@db
        console.error 'get from DB #{tableName} failed'
        @requestDo()
        return
      startLimit=startLimit||0
      endLimit=startLimit+@itemsMaxCount
      @db.transaction((tx)=>
        tx.executeSql("SELECT * FROM #{tableName} order by #{this.criteria} desc  limit #{startLimit},#{endLimit}", [], (tx,result)=>
          rowsLength=result.rows.length
          if rowsLength
            data=[]
            i=0
            while(i<rowsLength)
              data.push(result.rows.item(i))
              i++
          else data=false
          callback(data)
        ,(error)=>
          console.error('select db error')
          console.error(error)
          @requestDo()
        ,
        @querySuccess(tableName)
        )
      ,(error)=>
        console.error('transaction')
        console.error(error)
        if !error.code
         @initDatabase(()=>
          @requestDo()
         )

      )

    updateVisitedCommentsCountItem: (tableName, id, commentsCount,callback)=>
        @db.transaction((tx)=>
          sql="UPDATE  #{tableName} SET commentscount=?, visited='true'  WHERE id=?"
          tx.executeSql(sql, [parseInt(commentsCount), id]
                   (tx, resultSet) ->
                     if (!resultSet.rowsAffected)
#                       alert('No rows affected!');
                       console.error('No rows affected!');
                       return false;
                 )
        ,@errorHandler,
        ()->
          if(callback) then callback()
        );

    querySuccess: (tableName) =>
      console.log "select from db #{tableName} success"

    dropTable: (tableName) =>
      @db.transaction((tx) =>
        tx.executeSql("DROP TABLE #{tableName}",[],(tx,results)->
          console.log("Successfully Dropped")
        );
      )

    deleteRow: (tableName,id) =>
      @db.transaction((tx) =>
        tx.executeSql("DELETE FROM #{tableName} where id = ?",[id],(tx,results)->
          console.log("Successfully Dropped")
        );
      )

    getCachedImage:(onlineSrc,onGotCallback)=>
      if(typeof cordova=='undefined' )
              onGotCallback(onlineSrc) if typeof onGotCallback!="undefined" #use online src only for non-cordova version!
              return
      gotSrc=onlineSrc
      ImgCache.getCachedFile(onlineSrc,(onlineSrc, file_entry)=>
        if(file_entry)
          gotSrc=file_entry.toURL()
        else
          ImgCache.cacheFile(onlineSrc,
                  () =>
                    console.log('cached!')
                  ,()=> #on error
                    console.log('cache error!')
                  )
        onGotCallback(gotSrc)
      )

    prepareCachedImgsRecursive:(start, itemsCount, items, callback)=>
      i=0
      @prepareEachImg(i,start,itemsCount,items,callback)

    prepareEachImg:(i,start,itemsCount,items,callback)->
      index=start+i
      if(i<itemsCount&&index<items.length)
        @getCachedImage(items[index].smallImg,(cachedSrc)=>
          items[index].cachedSrc=cachedSrc
          i++;
          @prepareEachImg(i,start,itemsCount,items,callback)
        )

      else
        callback()

#

  return Cache


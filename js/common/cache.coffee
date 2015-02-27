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
      ImgCache.options.chromeQuota = 50*1024*1024;
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

    getSavedInfo:()->
#      delay=0
#      delay=1300 if @need2Update
      @getDataFromTable(@cachedTableName,(cachedData)=>
#         console.log(cachedData)
         if(cachedData&&cachedData.length)#if we had cache work witt it
             @data[@cachedTableName]=cachedData
             @listViewCallback(cachedData,@cachedTableName)
             @need2Update() if @need2Update
             return false #dont do any request
         #if db is empty
         console.info('DB is empty')
         @requestDo()
      )
    requestDo:()->
      url=@getUrl(@cachedTableName)
      console.log('%c REQUEST! ', 'background: #222; color: #bada55');
      baseApplication.sync.request(url,true,(data)=>
        if(data&&data.channel) #if we got info from the server
            @setTableData(@cachedTableName,data.channel.item,()=>
              console.log('onsaved')
              @getSavedInfo()
            )
        else #if we dont have information from internet
            if @need2Update
              setTimeout(()=>
                @need2Update() #just close pull ro refresh
              ,1000)
            else
              @listViewCallback(false,@cachedTableName) #just render witout data :(
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
      tx.executeSql("CREATE TABLE IF NOT EXISTS news (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, title TEXT,description TEXT,shortDescription TEXT, lastUpdate REAL, pubDate REAL , smallImg Text, commentscount INTEGER,commentscounturl TEXT,comments TEXT,visited BOOL,created REAL)", [], ()->
        console.log('table created')
      , @errorHandler)
      tx.executeSql("CREATE TABLE IF NOT EXISTS blogs (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, title TEXT,description TEXT,shortDescription TEXT, lastUpdate REAL, pubDate REAL , smallImg Text, commentscount INTEGER,commentscounturl TEXT,comments TEXT,visited BOOL,created REAL)", [], ()->
          console.log('table created')
        , @errorHandler)
      tx.executeSql("CREATE TABLE IF NOT EXISTS tv (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, title TEXT,description TEXT,shortDescription TEXT, lastUpdate REAL, pubDate REAL , smallImg Text, commentscount INTEGER,commentscounturl TEXT,comments TEXT,visited BOOL,created REAL)", [], ()->
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
      @getLastCriteriaUpdate(tableName,(criteria)=>
        @addEachItemsToDbRecursive(tableName,(data.length-1),data,criteria,onSaved) #data.length-1 - first save item index. We're saving to db from old to the latest
      )


    getLastCriteriaUpdate:(tableName,callback)=>
      @db.transaction((tx)=>
#              console.log(tableName)
              sql="SELECT #{this.criteria} FROM #{tableName} order by #{this.criteria} desc limit 1"
#              console.log(sql)
              tx.executeSql(sql, [], (tx,result)=>
                criteriaValue=false
                if(result.rows.length)
#                  console.log('YESS')
                  row=result.rows.item(0)
#                  console.log(row)
                  if(row&&row.hasOwnProperty(this.criteria))
                    criteriaValue=row[this.criteria]
#                    console.log(criteriaValue)
#                    console.log('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
                if callback then  callback(criteriaValue)
              ,(err)->
                console.log(err)
              )
      )

    addEachItemsToDbRecursive:(tableName,index,itemsArray,criteria,onSaved)->
     console.log(index)
     if index<0
       onSaved()
       return
#     console.log('index')
#     console.log(index)
     oneItem=itemsArray[index]
#     console.log(oneItem)
#     console.log(itemsArray)
#     console.log(lastUpdate)
#     console.log(criteria)
#     console.log(new Date(oneItem[this.criteria]).getTime())
#     console.log('---------------------------------')
     if(!criteria||criteria&&new Date(oneItem[this.criteria]).getTime()>criteria) #add in bd only if new items have bigger lastupdate then the newest in db
#       console.log('add')
       @addOneItemToDb(tableName,oneItem,()=>
             --index;
             @addEachItemsToDbRecursive(tableName,index,itemsArray,criteria,onSaved)
       )
     else
        --index;
        @addEachItemsToDbRecursive(tableName,index,itemsArray,criteria,onSaved)

    addOneItemToDb:(tableName,oneItem,callback)->
      @db.transaction((tx)=>
         lastUpdate=+oneItem.lastUpdate||+oneItem.lastupdate #server bug!
         tx.executeSql("INSERT OR REPLACE INTO #{tableName} (title,description,shortDescription,lastUpdate,pubDate,smallImg,commentscount,commentscounturl,comments, created) VALUES (?,?,?,?,?,?,?,?,?,?)", [oneItem.title,JSON.stringify(oneItem.description),oneItem.shortDescription,lastUpdate,parseInt(oneItem.createdUnix+"000"),oneItem.smallImg,+oneItem.commentscount,oneItem.commentscounturl,oneItem.comments, new Date().getTime()]
           (tx, resultSet) ->
             if (!resultSet.rowsAffected)
               alert('No rows affected!');
               return false;
         )
       ,@errorHandler,
       ()=>
          console.log('addOneItemToDb')
          @setCachedImage(oneItem.smallImg,()=>
            console.log('set to db and cache image success!')
            if(callback) then callback()
          )
       );

    getDataFromTable: (tableName,callback,startLimit) =>
      if !@db
        console.error 'get from DB #{tableName} failed'
        @requestDo(false)
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
          @requestDo(false)
        ,
        @querySuccess(tableName)
        )
      ,(error)=>
        console.error('transaction')
        console.error(error)
        if !error.code
         @initDatabase(()=>
          @requestDo(false)
         )

      )

    updateVisitedCommentsCountItem: (tableName, id, commentsCount,callback)=>
        @db.transaction((tx)=>
          sql="UPDATE  #{tableName} SET commentscount=?, visited='true'  WHERE id=?"
          tx.executeSql(sql, [parseInt(commentsCount), id]
                   (tx, resultSet) ->
                     if (!resultSet.rowsAffected)
                       alert('No rows affected!');
                       return false;
                 )
        ,@errorHandler,
        ()->
          if(callback) then callback()
        );

    querySuccess: (tableName) =>
      console.log "select from db #{tableName} success"

    dropTables: (tableName) =>
      @db.transaction((tx) =>
        tx.executeSql("DROP TABLE #{tableName}",[],(tx,results)->
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
        onGotCallback(gotSrc)
      )

    setCachedImage:(onlineSrc,onCachedCallback)->
      if(typeof cordova=='undefined' )
        onCachedCallback(onlineSrc) if typeof onCachedCallback!="undefined" #use online src only for non-cordova version!
        return
      ImgCache.cacheFile(onlineSrc,
      () =>
                  console.log('cached!')
#                  setTimeout(()=>
#                  onCachedCallback(onlineSrc)
#                  ,100)
      ,()=> #on error
        console.log('cache error!')
#        setTimeout(()=>
#        onCachedCallback(onlineSrc)
#        ,100)
      )
      onCachedCallback(onlineSrc)

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


define ['_','baseView','app', 'text!templates/oneItem.html'],
  (_, BaseView, app, template)->

        class OneItamNewsView extends BaseView
          template:template
          domTabsObj:[]
          events:
                "touchstart #share":"shareLink"
                "touchstart #comments_count":"commentsOpen"

          constructor: (query)->
            super


          onRender:()->
            setTimeout(()=>
              @$("#image").attr('src',@model.smallImg)
              @model.description.__cdata=@model.description.__cdata.replace(/\<iframe [^>]*src="http:\/\/www\.youtube\.com\/embed\/([^"]+)"[^>]*><\/iframe>/g,(match,$1)->
                console.log(match)
                console.log($1)
                return "<div class='youtube-play' ontouchstart=baseApplication.helpers.showVideo('"+$1+"')><img src='http://img.youtube.com/vi/#{$1}/mqdefault.jpg' alt='youtube-poster'></div>"
              )
              @model.description.__cdata=@model.description.__cdata.replace(/href="([\w:\/\/.-]+)"/g,@openLink())
              document.getElementById("contentOneItem").innerHTML=@model.description.__cdata
              baseApplication.sync.getComments(@model.commentscounturl,
                 (data)=>
                   if data&&@model.commentscount != data
                     @model.commentscount = data
                     @$("#comments_count").text(@model.commentscount)
                     @saveInCacheNewData()
                   if +@model.commentscount
                     @$("#comments_count").removeClass("no-comments")
               )
            ,1000) #terrible wait until animation works

          shareLink: =>
            buttons1 = [
              {
                text: 'Поделиться ссылкой',
                label: true
              },
              {
                text: 'E-Mail',
                onClick:=>
                  if(window.plugins)
                    window.plugins.socialsharing.shareViaEmail(
                      @model.link,
                      'Думская. Поделиться ссылкой',
                      null, #TO: must be null or an array
                      null, # CC: must be null or an array
                      null, #BCC: must be null or an array
                      null, #['https://www.google.nl/images/srpr/logo4w.png','www/localimage.png'],FILES: can be null, a string, or an array
                      ()->
                        console.log 'via email share ok'
                      , #called when sharing worked, but also when the user cancelled sharing via email (I've found no way to detect the difference)
                      ()->
                        console.log 'via email share FALSE'
                      # called when sh*t hits the fan
                    )
              },
              {
                text: 'Twitter'
                onClick:()=>
                  if(window.plugins)
                    window.plugins.socialsharing.shareViaTwitter(@model.link, null, null,
                      ()->
                        console.log('post via twitter success')
                      , (error)->
                        app.alert('Установите программу Twitter')
                        console.log(error))

              },
              {
                text: 'Facebook',
                onClick:()=>
                  if(window.plugins)
                    window.plugins.socialsharing.shareViaFacebook(@model.link, null , null ,
                      ()->
                        console.log('share ok')
                      ,(errormsg)->
                        app.alert('Установите программу Facebook')
                        console.log(errormsg))
              },
#              {
#                text: 'Выбрать другую программу',
#                onClick:()=>
#                  if(window.plugins)
#                    window.plugins.socialsharing.shareViaWhatsApp('Вибрать другую программу', null, null ,
#                      ()->
#                        console.log('share ok')
#                      , (errormsg)->alert(errormsg))
#              },
              {
                text: 'Копировать ссылку',
                onClick:()=>
                  if(window.cordova&&window.cordova.plugins)
                    window.cordova.plugins.clipboard.copy(@model.link);
              },
            ]
            buttons2 = [
              {
                text: 'Отмена',
                color: 'red'
              }
            ]
            groups = [buttons1, buttons2];
            app.actions(groups)

          commentsOpen: =>
            baseApplication.router.loadPage("comments",{model:{commentsUrl: @model.comments},viewParams:{swipeBackPage:true}})

          saveInCacheNewData:()->
            baseApplication.cache.data[@model.cacheClass].channel.item[@model.index]=@model
            baseApplication.cache.setTableData(@model.cacheClass,baseApplication.cache.data[@model.cacheClass])



        return OneItamNewsView

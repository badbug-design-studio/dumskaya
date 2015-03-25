define ['_','baseView', 'text!templates/comments.html'],
  (_, BaseView, template)->

        class CommentsView extends BaseView
          template:template
          domTabsObj:[]

          constructor:(query)->
            super


          onRender:()->
            setTimeout(()=>
              baseApplication.sync.getComments(@model.commentsUrl,
                (data)=>
                  html="<div class='text-centered'>Проблема с интернет-соединением. Попробуйте позже.</div>"
                  if data
                    data=data.toString().split('</style>')
                    if(data.length>1) then  html=data[1] else html=data[0]
                    html=html.replace(/href=([\w:\/\/.-]+)/g,@openLink())
                    html=html.replace(/\<iframe [^>]*src="http:\/\/www\.youtube\.com\/embed\/([^"]+)"[^>]*><\/iframe>/g,(match,$1)->
                      return "<div class='youtube-play' onclick=baseApplication.helpers.showVideo('"+$1+"')><img src='http://img.youtube.com/vi/#{$1}/mqdefault.jpg' alt='youtube-poster'></div>"
                    )

                  document.getElementById("commentsOneItem").innerHTML=html
                )
              history.pushState({page: 'comments'})
            ,1000)



        return CommentsView

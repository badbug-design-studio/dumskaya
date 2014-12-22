define ['_','baseView', 'text!templates/comments.html'],
  (_, BaseView, template)->

        class CommentsView extends BaseView
          template:template
          domTabsObj:[]

          constructor:(query)->
            super


          onRender:()->
            baseApplication.sync.getComments(@model.commentsUrl,
            (data)=>
              data=data.toString().split('</style>')
              if(data.length>1) then  html=data[1] else html=data[0]
              @$('.comments-page .item-page-wrap').html(html)
            )


        return CommentsView

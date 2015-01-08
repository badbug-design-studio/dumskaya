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
                  data=data.toString().split('</style>')
                  if(data.length>1) then  html=data[1] else html=data[0]
                  @$('#commentsOneItem').html(html)
                )
            ,1000)



        return CommentsView

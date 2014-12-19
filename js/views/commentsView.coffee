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
#              console.log data
              @$('.comments-page').append(data)
              @$('.preloader-indicator-modal').hide()
            )


        return CommentsView

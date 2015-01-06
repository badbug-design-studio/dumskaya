define ['_','baseView','app', 'text!templates/oneItem.html'],
  (_, BaseView, app, template)->

        class OneItamNewsView extends BaseView
          template:template
          domTabsObj:[]
          events:
                "click .share":"shareLink"
                "click .comments-link":"commentsOpen"

          constructor: (query)->
            super



          onRender:()->
            setTimeout(()=>
              @$("#contentOneItem").html(@model.description.__cdata)
            ,1000) #terrible wait until animation works



          shareLink: ->
            buttons1 = [
              {
                text: 'Заголовок статті',
                label: true
              },
              {
                text: 'E-Mail'
              },
              {
                text: 'Twitter'
              },
              {
                text: 'Facebook'
              },
              {
                text: 'Копіювати посилання'
              },
            ]
            buttons2 = [
              {
                text: 'Відмінити',
                color: '#8a1020'
              }
            ]
            groups = [buttons1, buttons2];
            app.actions(groups)

          commentsOpen: =>
            baseApplication.router.loadPage("comments",{model:{commentsUrl: @model.comments},viewParams:{swipeBackPage:true}})

        return OneItamNewsView

define ['_','baseView','app', 'text!templates/oneItemNews.html'],
  (_, BaseView, app, template)->

        class OneItamNewsView extends BaseView
          template:template
          domTabsObj:[]
          events:
                "click .share":"shareLink"

          constructor:(query)->
            super


          onRender:()->
            console.log @model.title if @model

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


        return OneItamNewsView

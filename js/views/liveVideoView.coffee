define ['_', 'baseView','text!templates/liveVideo.html'],
  (_, BaseView, template)->

    class LiveVideo extends BaseView
      template:template
      cacheClass:"lv"
      model:
        name: "Онлайн трансляция"
        frameParams:
          src: "http://live-tv.od.ua/tv/dumskaya.php?a=1&cnee&ff=1"
          width: window.innerWidth
          height: window.innerHeight/2
#      itemSelector:".item-content"
#          events:
#            "click .news-list .item-content":"openOneItem"

      constructor:(query)->
        #'<iframe name="dumvideo" width="640" height="440" src="http://live-tv.od.ua/tv/dumskaya.php?w=640&h=440&a=1&cnee&ff=1" style="background-color:black;padding:0;margin:0;border:0;" allowtransparency frameBorder="0" hspace="0" vspace="0" marginheight="0" marginwidth="0" scrolling="no" >'
        @model.frame = "iokloim"
        super

      onRender:()->




    return LiveVideo

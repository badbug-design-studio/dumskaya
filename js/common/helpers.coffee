define ['f7','_'],
(Framework7,_)->
  class Helpers
    $: Framework7.$
    date:new Date()

    months:[
      {
        name:'января',
        shortName:'янв.',
      },{
        name:'февраля',
        shortName:'фев.',
      },{
        name:'марта',
        shortName:'март.',
      },{
        name:'апреля',
        shortName:'апр.',
      },{
        name:'мая',
        shortName:'мая',
      },{
        name:'июня',
        shortName:'июн.',
      },{
        name:'июля',
        shortName:'июл.',
      },{
        name:'августа',
        shortName:'авг.',
      },{
        name:'сентября',
        shortName:'сент.',
      },{
        name:'октября',
        shortName:'окт.',
      },{
        name:'ноября',
        shortName:'нояб.',
      },{
       name:'декабрь',
       shortName:'дек.',
      }
    ]

    getMonthName:(index,isShort)->
      prop='name'
      prop='shortName' if isShort
      return @months[index][prop]

    getShortItemDate:(dateString,isShort)->
     date=new Date(dateString)
     day=date.getDate()
     month=date.getMonth()
     monthName=@getMonthName(date.getMonth(),true)
     year=date.getFullYear()
     minutes = date.getMinutes()
     if (minutes<10)
        minutes = "0" + minutes
     time=if isShort then '' else date.getHours()+":"+ minutes
     if((day==@date.getDate())&&(month==@date.getMonth())&&(year==@date.getFullYear()))
       return "Сегодня "+time
     else if(((day+1)==@date.getDate())&&(month==@date.getMonth())&&(year==@date.getFullYear()))
       return "Вчера "+time
     else
       return day+" "+monthName+" "+year

    getTime: (dateString)->
      date=new Date(dateString)
      minutes = date.getMinutes()
      if (minutes<10)
        minutes = "0" + minutes
      time=date.getHours()+":"+ minutes
      return time

    compareTwoDates: (dateString1, dateString2) ->
      date1 = new Date(dateString1)
      date2 = new Date(dateString2)
      return date1.getFullYear() == date2.getFullYear() && date1.getMonth() == date2.getMonth() && date1.getDate() == date2.getDate()

    showVideo:(videoId)->
      if(!@videoFrame)
        @videoFrame=document.getElementById('video-frame')
      baseApplication.f7app.popup('#popup-video');
      setTimeout(()=>
        @videoFrame.setAttribute('src',"http://www.youtube.com/embed/#{videoId}?rel=0&autoplay=1")
      ,1000)


    closeVideo:()->
      window.stop()
      baseApplication.f7app.closeModal()
      setTimeout(()=>
        @videoFrame.setAttribute('src','')
      ,300)


    pullToRefreshSwipe:(domEl, callback,swipeLeft,swipeRight)->
      parentThis=this
      callback=callback||false
      touchYStart=0
      touchXStart=0
      touchXEnd=0
      distance=0
      scrollTop=0
      swipe=false
      preloader=false


      updateDistance=60;
      update=(callback)->
         self=this;
         this.style.transitionDuration='300ms'
         this.style.webkitTransform="translate3d(0,50px,0)"
         body.classList.add('disable-touch')
         setTimeout(()->
           self.style.transitionDuration='0ms'
           callback() if(callback)
#           finish.call(self)
         ,1500)

      body=document.getElementById('body')
      finish=()->
        this.style.transitionDuration='300ms'
        this.style.webkitTransform="translate3d(0,0,0)"
        self=this
        body.classList.remove('dragging')
        setTimeout(()->
         self.style.transitionDuration='0ms'
         body.classList.remove('ptr-refresh')
         body.classList.remove('ptr-loading')
        ,300)

      domEl.addEventListener("touchstart",
          (event) ->
           #   console.log('start');
           touchYStart=event.touches[0].pageY
           touchXStart=event.touches[0].pageX
           scrollTop=this.scrollTop
      , false);

      domEl.addEventListener("touchmove",
          (event)->
#             distanceX=event.touches[0].pageX-touchXStart
             touchXEnd=event.touches[0].pageX
             distance=event.touches[0].pageY-touchYStart
#             console.log Math.abs(distanceX)
#             if(!preloader&&Math.abs(distanceX)>=20&&!swipe&&distance<Math.abs(distanceX))
#                 swipe=true
#             else
#                preloader=true
             console.log(swipe)
             console.log(preloader)
             console.log('-------------')
#             console.log(swipe)
#             if(swipe)
#               return
             if(scrollTop)
                return
#             console.log(distance)
             if(distance>=0)#only down direction!
               body.classList.add('dragging')
               this.style.webkitTransform="translate3d(0,"+distance+"px,0)"
             if(distance>=updateDistance)
               body.classList.add('ptr-refresh')
             else
               body.classList.remove('ptr-refresh')

      , false);
      domEl.addEventListener("touchend",
          (event)->
#             console.log 'SWIPE!!!!!!!!!!!!!!!!!'
##             console.log swipe
#             if(swipe)
#               if(touchXEnd-touchXStart<0)
#                 swipeLeft.apply(parentThis)
#               else
#                 swipeRight.apply(parentThis)
#               swipe=false
#               finish.call(this)
#             else
               if(distance>updateDistance)
                 body.classList.add('ptr-loading')
                 console.log('update');
                 update.call(this,callback)
               else
                 console.log('go back')
                 finish.call(this)
               preloader=false
      , false);

  return Helpers


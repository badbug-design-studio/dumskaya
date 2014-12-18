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

  return Helpers


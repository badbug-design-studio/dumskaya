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

    getShortItemDate:(dateString)->
     date=new Date(dateString)
     day=date.getDate()
     month=date.getMonth()
     monthName=@getMonthName(date.getMonth(),true)
     year=date.getFullYear()
     time=date.getHours()+":"+date.getMinutes()
     if((day==@date.getDate())&&(month==@date.getMonth())&&(year==@date.getFullYear()))
       return "Сегодня "+time
     else if(((day+1)==@date.getDate())&&(month==@date.getMonth())&&(year==@date.getFullYear()))
       return "Вчера "+time
     else
       return day+" "+monthName+" "+year+", "+time

  return Helpers


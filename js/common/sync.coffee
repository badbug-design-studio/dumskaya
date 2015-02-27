define ['_','xml2json'],
(_,xml2json)->
  class SyncServices

    $: Framework7.$
    isProd:true

    constructor:()->
       @x2js = new X2JS();

    getNewsRssUrl:()=>
        ext='/'
        if !@isProd
          ext='.xml'
        return @getRoot()+"rssios"+ext

    getBlogsRssUrl:()=>
        ext='/'
        if !@isProd
          ext='.xml'
        return @getRoot()+"rssblogs"+ext


    getTVRssUrl:()=>
        ext='/'
        if !@isProd
          ext='.xml'
        return @getRoot()+"rsstv"+ext

    getArticlesRssUrl:()=>
      ext='/'
      if !@isProd
        ext='.xml'
      return @getRoot()+"articles"+ext

    getRoot:()->
      if @isProd
        return "http://dumskaya.net/"
      else return "./rss/"

    request:(url,isXML,onSuccess)->
      self=@;
      xmlHttp=new XMLHttpRequest();

      xmlHttp.open('GET', url+"?#{Date.now()}", true);
      xmlHttp.timeout = 8500;
      xmlHttp.onreadystatechange = ()->
         if (xmlHttp.readyState != 4) then return
         if(xmlHttp.status == 200)
           response=xmlHttp.responseText
           if isXML
            response= xmlHttp.responseText.replace(/\<\?xml.+\?\>/,"")
            response=self.x2js.xml_str2json(response);
            response=response.rss if response
#            console.log(response)
#           resolve(response);
           onSuccess(response)
         else
            console.error "xmlHttpRequest error status #{xmlHttp.status} and url #{url}"
            console.log(xmlHttp)
            onSuccess(false,xmlHttp.statusText) if onSuccess
#            reject(xmlHttp.statusText) if reject
      xmlHttp.send()
#      );
#      return promise
    getComments: (url, callback) ->
#      if /http:\D{2}/.test url
#        url = url.replace(/http:\D{2}/, "http://www.corsproxy.com/")
      @request(url, false, callback, ()-> console.error('comments get error'))

#xmlhttp.send(null);

  return SyncServices


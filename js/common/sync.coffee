define ['_'],
(_)->
  class SyncServices

    $: Framework7.$

    request:(url)->
      xmlHttp=new XMLHttpRequest();
      xmlHttp.open('GET', url, true);
      promise = new Promise((resolve, reject)->
        xmlHttp.onreadystatechange = ()->
         if (xmlHttp.readyState != 4) then return
         if(xmlHttp.status == 200)
           alert('good');
           resolve(xmlHttp.responseText);
         else
            console.error "xmlHttpRequest error status #{xmlHttp.status} and url #{url}"
            reject(xmlHttp.statusText) if reject
        xmlHttp.send()
      );
      return promise


#xmlhttp.send(null);

  return SyncServices


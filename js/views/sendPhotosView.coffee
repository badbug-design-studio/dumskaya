define ['_','baseView','text!templates/sendPhotos.html'],
(_, BaseView,template)->

  class SendPhotosView extends BaseView
    template:template

    constructor:(query)->
      super


    onRender:()->
      @sendForm()
      self=@
      @$("#file").change(()->
        self.readURL(this);
      );

    onPageBeforeAnimation:()->
      console.log("onPageBeforeAnimation")

    sendForm: ()->
      @$('#form').on('submit', (e) ->
        console.log e
        e.preventDefault()
        formData = new FormData(@)
        xmlHttp=new XMLHttpRequest();

        xmlHttp.open('POST', @.getAttribute("action"), true);
        xmlHttp.onreadystatechange = ()->
          if (xmlHttp.readyState != 4) then return
          if(xmlHttp.status == 200)
            console.log xmlHttp.responseText
            match = xmlHttp.responseText.toString().match(/success:(\d+), error:"(\w*)"/)
            if match && parseInt(match[1])
              alert("Картика отправлена")
            else
              alert("Все печально")
          else
            alert("Попробуйте позже")
        xmlHttp.send(formData)
      )

    readURL:(input)->
      if (input.files && input.files[0])
          reader = new FileReader();
          reader.onload =  (e) ->
             img= Framework7.$('#imgPreView')
             img.attr('src', e.target.result);
             img.show()

          reader.readAsDataURL(input.files[0]);


  return SendPhotosView

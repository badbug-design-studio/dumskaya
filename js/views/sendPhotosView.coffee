define ['_','f7','baseView','text!templates/sendPhotos.html'],
(_, f7, BaseView,template)->

  class SendPhotosView extends BaseView
    template:template

    constructor:(query)->
      super


    onRender:()->
      setTimeout(()=>
         @sendForm()
#         @clicks()
         self=@
         @inputFile = document.getElementById("file")
         @inputFile.onchange = ()->
           self.readURL(this);
      ,1000)


    onPageBeforeAnimation:()->
      console.log("onPageBeforeAnimation")

    sendForm: ()->
      self=@
      @$('#form').on('submit', (e) ->
        e.preventDefault()
        if (!self.inputFile.value)
          baseApplication.f7app.alert("Пожалуйста добавьте фото")
          return
        else
          self.$('#send-button').addClass('in-progress')
          form=this
          formData = new FormData(@)
          xmlHttp=new XMLHttpRequest();

          xmlHttp.open('POST', @.getAttribute("action"), true);
          xmlHttp.onreadystatechange = ()->
            if (xmlHttp.readyState != 4) then return
            self.$('#send-button').removeClass('in-progress')
            if(xmlHttp.status == 200)
              console.log xmlHttp.responseText
              match = xmlHttp.responseText.toString().match(/success:(\d+), error:"(\w*)"/)
              if match && parseInt(match[1])
                 form.reset()
                 Framework7.$('#imgPreView').hide()
                 baseApplication.f7app.alert('Картика отправлена')
              else
                baseApplication.f7app.alert("Не удается отправить фото, попробуйте позже")
            else
              baseApplication.f7app.alert("Попробуйте позже")
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
    clicks: ()->
      @$('#file-button').on("touchend", ()=>
        @$('#file').click()
      )

  return SendPhotosView

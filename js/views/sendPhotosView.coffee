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
          console.log formData
          xmlHttp.open('POST', @.getAttribute("action"), true);
          xmlHttp.onreadystatechange = ()->
            if (xmlHttp.readyState != 4) then return
            self.$('#send-button').removeClass('in-progress')
            if(xmlHttp.status == 200)
              console.log xmlHttp.responseText
              match = xmlHttp.responseText.toString().match(/success:(\d+), error:"(\w*)"/)
              if match && parseInt(match[1])
                 form.reset()
                 Framework7.$('#imgPreView').html('')
                 baseApplication.f7app.alert('Картика отправлена')
              else
                baseApplication.f7app.alert("Не удается отправить фото, попробуйте позже")
            else
              baseApplication.f7app.alert("Не удается отправить фото, попробуйте позже")
          xmlHttp.send(formData)
      )

    readURL:(input)->
      console.log(input.files)
      if (input.files)
         imgStack = document.createDocumentFragment()
         filesArrLength = input.files.length
         @appendImg(input, imgStack, 0, filesArrLength)

    appendImg: (input, imgStack, index, filesArrLength)->
      if (index == filesArrLength)
        document.getElementById("imgPreView").innerHTML=""
        document.getElementById("imgPreView").appendChild(imgStack)
        return
      reader = new FileReader();
      reader.onload =  (e) =>
        index++
        img = document.createElement("img");
        img.setAttribute('src', e.target.result);
        imgStack.appendChild(img);
        img.style.display="block"
        @appendImg(input,imgStack, index, filesArrLength)
      reader.readAsDataURL(input.files[index]);

    clicks: ()->
      @$('#file-button').on("touchend", ()=>
        @$('#file').click()
      )

  return SendPhotosView

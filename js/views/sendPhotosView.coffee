define ['_','f7','baseView','text!templates/sendPhotos.html'],
(_, f7, BaseView,template)->

  class SendPhotosView extends BaseView
    template:template
    imgs4Upload:[]
    serverUrl:"http://dumskaya.net/mobilesendphoto//send/?app=1" #"http://10.37.4.250:3000/images"

    constructor:(query)->
      super


    onRender:()->
      setTimeout(()=>
        isAndroid=window.cordova&&device.platform=='Android'
        console.log isAndroid
        if(isAndroid)
          @androidFileInit()
        else
          @formEventsInit()

      ,1000)
    androidFileInit:()->
      @$('#file').hide()
      @$('#file-button').on("touchend", ()=>
        @takePhoneGapPicture()
      )
      @$('#form').on('submit', (e) =>
        e.preventDefault()
        @$('#send-button').addClass('in-progress')
        console.log('ONSUBMIT')
        @setPictureLabel(@imgs4Upload.length)

        _.each(@imgs4Upload,(src,index)=>
          console.log(src)
          @phonegapUpload(src,index)
        )
      )

    takePhoneGapPicture:()->
      options =
         quality: 50,
         destinationType: Camera.DestinationType.FILE_URI,
         sourceType: Camera.PictureSourceType.PHOTOLIBRARY

      navigator.camera.getPicture((imageURI)=>
              console.log(imageURI)
              @imgs4Upload.push(imageURI)
              @addImgPreview(document.getElementById("imgPreView"),imageURI)
#             upload(imageURI);
      ,(message)->
             # We typically get here because the use canceled the photo operation. Fail silently.
             console.log('cancel')
      ,options);

      return

    formEventsInit:()->
      @sendForm()
      @inputFile = document.getElementById("file")
      @inputFile.onchange = (event)=>
        @readURL(event.target.files);

    onPageBeforeAnimation:()->
      console.log("onPageBeforeAnimation")

    sendForm: ()->
      self=@
      @$('#form').on('submit', (e) ->
        e.preventDefault()
        if (!self.inputFile.value)
          baseApplication.f7app.alert("Пожалуйста добавьте фото.")
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
                 self.showMessage(true)
              else
                self.showMessage(false)

            else
              self.showMessage(false)
          xmlHttp.send(formData)
      )

    readURL:(files)->
      console.log(files)
      if (files)
         imgStack = document.createDocumentFragment()
         filesArrLength = files.length
         @setPictureLabel(filesArrLength)
         @appendImg(files, imgStack, 0, filesArrLength)

    appendImg: (files, imgStack, index, filesArrLength)->
      if (index == filesArrLength)
        document.getElementById("imgPreView").innerHTML=""
        document.getElementById("imgPreView").appendChild(imgStack)
        return
      reader = new FileReader();
      reader.onload =  (e) =>
        index++
        @addImgPreview(imgStack,e.target.result)
        @appendImg(files,imgStack, index, filesArrLength)
      reader.readAsDataURL(files[index]);

    addImgPreview:(placeWhere,src)->
      img = document.createElement("img");
      img.setAttribute('src', src);
      placeWhere.appendChild(img);
      img.style.display="block"

    clicks: ()->
      @$('#file-button').on("touchend", ()=>
        @$('#file').click()
      )
    showMessage:(isTrue)->
      if isTrue
        baseApplication.f7app.alert(@pictureLabel)

      else
        baseApplication.f7app.alert("Не удается отправить фото, попробуйте позже.")

    setPictureLabel:(count)=>
      if(count>1)
        @pictureLabel="Картинки отправлены."
      else
        @pictureLabel="Картинка отправлена."

      console.log('setPictureLabel')

    phonegapUpload:(fileURI,index)=>
     console.log('upload!')
     console.log(fileURI)
     options = new FileUploadOptions();
     options.fileKey = "picture";
     options.fileName = fileURI.substr(fileURI.lastIndexOf('/') + 1);
     console.log(options.fileName)
     options.mimeType = "image/jpeg";
     options.params = new Object();
     options.params.name=@$('#picture_name').val()
     options.params.text=@$('#picture_description').val()

       # if we need to send parameters to the server request
     ft = new FileTransfer();
     ft.upload(fileURI, encodeURI(@serverUrl), (data)=>
       console.log('GOOOD!')
       if (index==(@imgs4Upload.length-1))
         console.log data
         match = data.response.match(/success:(\d+)/)
         if match && parseInt(match[1])
          @showMessage(true)
         else
           @showMessage(false)
         @imgs4Upload=[]
         document.getElementById("imgPreView").innerHTML=""
         @$('#send-button').removeClass('in-progress')
         @$('#form')[0].reset()
     , (data)=>
         console.log(data)
         console.log('BAD!')
         @showMessage(false)
     , options);


  return SendPhotosView

library(shiny)
library(filesstrings)

shinyServer <- function(input, output, session) {
    
    library(magick)
        
    output$info<- renderPrint({
        imagefile=file.path("./www",input$image)
        myimage<-image_read(imagefile)
        output$filename = renderText({input$image})
        as.data.frame(image_info(myimage))
    })
   

    output$img <- renderImage({
        
        imagefile=file.path("./www",input$image)
        myimage<-image_read(imagefile)
        tmpfile <- myimage %>%
            image_write(tempfile(fileext='jpeg'), format = 'jpg')
        list(src = tmpfile, contentType = "image/jpeg")
    })
    
    output$imga <- renderImage({
        imagefile=file.path("./www",input$image)
        myimage<-image_read(imagefile)
        tmpfile <- myimage %>%
            image_modulate(saturation=input$sat, brightness=input$bright, hue=input$hue) %>%
            image_write(tempfile(fileext='jpeg'), format = 'jpg')
        list(src = tmpfile, contentType = "image/jpeg")
    })
    
    observeEvent(input$reset_btn, {
        updateSliderInput(session,"sat",value=100)
        updateSliderInput(session,"hue",value=100)
        updateSliderInput(session,"bright",value=100)
    })
    
    
    observeEvent(input$save_btn, {
        imagefile=file.path("./www",input$image)
        myimage<-image_read(imagefile)
        newImage<-image_modulate(myimage,saturation=input$sat, brightness=input$bright, hue=input$hue)
      
        newname<-give_ext(before_last_dot(imagefile), input$myformat)
        image_write(newImage,path=newname,format=input$myformat)
        
        output$filename = renderText({newname})
        file.list<-list.files(path="./www",pattern="*")
        updateSelectInput(session, inputId='image',label='Image', choices=file.list,
                    selected=NULL)
        updateSliderInput(session,"sat",value=100)
        updateSliderInput(session,"hue",value=100)
        updateSliderInput(session,"bright",value=100)
    })
      
}

#shinyApp(ui, server)
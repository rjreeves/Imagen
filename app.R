library(shiny)
library(filesstrings)
ui <- fluidPage(
    titlePanel("Imagen"),
    
    sidebarLayout(
        
        sidebarPanel(
            file.list<-list.files(path="./www",pattern="*"),
            selectInput(inputId='image',label='Image', choices=file.list,
                          selected=NULL,multiple=F
            ),
                      
            
            sliderInput("sat", "Saturation", min = 0, max = 200, value = 100),
            sliderInput("bright", "Brightness", min = 50, max = 150, value = 100), 
            sliderInput("hue", "Hue", min = -180, max = 180, value = 100),
            
            radioButtons("myformat", "Save Format",
                         c("png"="png",
                           "jpg"='jpg',
                           "bmp"="bmp",
                           "svg"="svg")),
            
            textOutput("filename"),
            actionButton("save_btn", "Save")
        ),
        
        mainPanel(
            verbatimTextOutput("info"),
           
            imageOutput(outputId = "img"),
      
            tags$br(),
            tags$br(),
            tags$br(),
            tags$br(),
            tags$br(),
            tags$br(),
            tags$br(),
       
            imageOutput(outputId = "imga")
            
         )
     )
)

server <- function(input, output, session) {
    
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
    
    
    observeEvent(input$save_btn, {
        imagefile=file.path("./www",input$image)
        myimage<-image_read(imagefile)
        
        image_modulate(myimage,saturation=input$sat, brightness=input$bright, hue=input$hue)
        newname<-give_ext(before_last_dot(imagefile), input$myformat)
        image_write(myimage,path=newname,format=input$myformat)
        output$filename = renderText({newname})
    })
      
}


shinyApp(ui, server)
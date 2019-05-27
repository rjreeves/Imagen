library(shiny)
library(filesstrings)

shinyUi <- fluidPage(
    titlePanel("Imagen"),
    
    sidebarLayout(
        
        sidebarPanel(
            file.list<-list.files(path="./www",pattern="*"),
            selectInput(inputId='image',label='Image', choices=file.list,
                          selected=NULL,multiple=F
            ),
                      
            
            sliderInput("sat", "Saturation", min = 0, max = 200, value = 100),
            sliderInput("bright", "Brightness", min = 50, max = 150, value = 100), 
            sliderInput("hue", "Hue", min = 0, max = 360, value = 100),
            
            actionButton("reset_btn", "Reset"),
            tags$br(),
            tags$hr(),
            
            radioButtons("myformat", "Save Format",
                         c("png"="png",
                           "jpg"='jpg',
                           "bmp"="bmp",
                           "tif"="tiff")),
            
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

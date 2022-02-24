
library(shiny)

# ------------------- User interface
ui <- fluidPage(
    selectInput(inputId = "greeting", label = "Who do you want to greet?", 
                choices = c("world" = "Hello, world!", "friends" = "Hi, friends!", 
                            "people" = "Hey, people!")),
    textOutput("full_greeting")
)

# ------------------- Server
server <- function(input, output, session) {
    output$full_greeting <- renderText(input$greeting)
}

shinyApp(ui, server)
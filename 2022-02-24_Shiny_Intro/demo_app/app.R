
library(shiny)

# ------------------- User interface
ui <- fluidPage(
    sliderInput(inputId = "age", label = "How old are you?", min = 1, max = 80, value = 6),
    textOutput("age_greeting")
)

# ------------------- Server
server <- function(input, output, session) {
    output$age_greeting <- renderText({
        dog_age <- input$age * 7,
        fish_age <- input$age * 45
        age_greeting <- paste("That's ", dog_age, " in dog years and ", fish_age, " in fish years!")
    })
}

shinyApp(ui, server)




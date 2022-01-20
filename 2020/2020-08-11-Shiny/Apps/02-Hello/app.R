#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel(""),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         textInput(inputId = "text",
                     label = "Write what you want, you do not have to be creative",
                     value = "")
      ),
      # Show a plot of the generated distribution
      mainPanel(
         textOutput("user_text")
      )
   )
)

# Define server logic 
server <- function(input, output) {

output$user_text <- renderText({ 
  paste("This shows what you are writing: " , input$text)
})

}
# Run the application 
shinyApp(ui = ui, server = server)


#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
n <- 50

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel(""),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         
         sliderInput(inputId = "n",
                     label = "Dataset size",
                     min = 0,
                     max = 100,
                     value = n),
         textInput(inputId = "text",
                     label = "Insert the title of the plot",
                     value = "")
      ),
      # Show a plot of the generated distribution
      mainPanel(
         h2(textOutput("user_text")),
         plotOutput("hist")
      )
   )
)

# Define server logic 
server <- function(input, output) {

output$user_text <- renderText({ 
  paste(input$text)
})

output$hist <- renderPlot({ 
  hist(rnorm(input$n), main = "")
})

# Instead of adding renderPlot and renderText you could do

# output$hist <- renderPlot({ 
#    hist(rnorm(input$n), main = input$text)
# })

# This solution will work but the behavior is not idea, why?



}
# Run the application 
shinyApp(ui = ui, server = server)


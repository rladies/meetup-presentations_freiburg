# Required Libraries can go here
require(shiny)

# Global variables can go here
n <- 50


# Define the UI
ui <- fluidPage(
  titlePanel("Simplest Shiny App"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "n", 
               label = "Number of obs", 
               min = 0,
               max = 100,
               value = n)
      ),
  
    mainPanel(plotOutput("hist"))
  )
)


# Define the server code
server <- function(input, output) {
  
  title <- "Normal distribution"
  xlabel <- "Value"
  
  output$hist <- renderPlot({
    hist(rnorm(input$n), main = title, xlab = xlabel)
  })
}

# Return a Shiny app object
shinyApp(ui = ui, server = server)

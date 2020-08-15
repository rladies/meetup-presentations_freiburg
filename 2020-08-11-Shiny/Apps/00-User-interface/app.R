#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
ui <- fluidPage(
  titlePanel(tags$h1("Title panel - Sidebar Layout")),
  
  sidebarLayout(
    sidebarPanel(tags$h2("Sidebar panel")),
    mainPanel(tags$h3("Main panel"))
  )  
)

server <- function(input, output) {
}


# Return a Shiny app object
shinyApp(ui = ui, server = server)
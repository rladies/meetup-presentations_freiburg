
#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(tidyverse)
library(ggplot2)
library(gridExtra)

# library(palmerpenguins)

penguins <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-28/penguins.csv')
# Define UI for application that draws a histogram

my_data <- penguins

ui <- fluidPage(
  
  # Application title
  titlePanel(tags$h6("Penguin Data")),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      radioButtons(inputId = "value",
                label = "Select the penguins characteristic",
                choices = c("Culmen Length (mm)" = "bill_length_mm", 
                            "Culmen depth (mm)" = "bill_depth_mm",
                            "Flipper length" = "flipper_length_mm", 
                            "Body Mass"  = "body_mass_g")
                ),
    tags$img(img(src = "penguins2.png", height = 200, width = 300))
    ),
    # Show a plot of the generated distribution
   mainPanel(
    plotOutput("histogram")
    )
  )
)

# Define server logic 
server <- function(input, output) {
  
  output$histogram <- renderPlot({ 
  
    my_data <- penguins %>% rename(value  = input$value )
    

    ylabel <- switch(input$value,
                   "bill_length_mm" = "Culmen Length (mm)", 
                   "bill_depth_mm" = "Culmen depth (mm)",
                   "flipper_length_mm" = "Flipper length (mm)", 
                   "body_mass_g"  = "Body Mass (g)")
    
    
      my_data %>%  ggplot(aes(fill = species)) +
      #   
      geom_histogram(aes(value), alpha = 0.5) +
      geom_rug(aes(value)) +
      facet_grid(species~.) +
      theme_minimal() +
      ylab ("Frequency") +
      xlab(ylabel) + 
      theme(legend.position = "none") +
      scale_fill_manual(values = c("darkorange","darkorchid","cyan4"))
  })
  
}
# Run the application 
shinyApp(ui = ui, server = server)


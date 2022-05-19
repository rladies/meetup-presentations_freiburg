
library(shiny)
library(tidyverse)

ui <- fluidPage(
  
  titlePanel("Eurovision Results"),
  
  sidebarLayout(
    sidebarPanel(
      
      selectInput(
        inputId = "year",
        label = "Which year would you like to see?",
        choices = c(2004:2019, 2021, 2022)
      ),
      
      sliderInput(
        inputId = "rank",
        label = "How many countries would you like to see?",
        min = 2,
        max = 10,
        value = 3,
        ticks = FALSE
      ),
    ),
    
    mainPanel(
      textOutput("title"),
      textOutput("subtitle"),
    
      plotOutput("eurov_bar")
    )
)
)

server <- function(input, output) {

  eurovision <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-05-17/eurovision.csv') %>% 
    filter(section == "grand-final")
  
  output$eurov_bar <- renderPlot(
    eurovision %>% 
    filter(year == input$year & rank <= input$rank) %>% 
    ggplot(aes(x = reorder(artist_country, -total_points), y = total_points, fill = artist_country)) +
    geom_col(show.legend = F) +
    labs(
      y = "Total points",
      x = "Country"
    ) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, vjust = 0.8))
    )
  
  output$title <- renderText(
    paste("Eurovision Finale", input$year)
  )
  
  output$subtitle <- renderText(
    paste("Showing the top", input$rank, "countries in terms of total points")
  )
  
}

shinyApp(ui = ui, server = server)

library(shiny)
library(tidyverse)

ui <- fluidPage(
    selectInput(
        inputId = "country", 
        label = "Which country would you like to see?", 
        choices = c("Germany", "France", "England", "Spain", "Italy", "Poland")
                ),
    plotOutput("medals")
)

server <- function(input, output, session) {
    
    summary_table <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-08-03/athletes.csv') %>% 
        mutate(medal = factor(medal, levels = c("Bronze", "Silver", "Gold"))) %>% 
        group_by(medal, country, year) %>% 
        summarize(N = n())
    
    output$medals <- renderPlot(
        summary_table %>% 
            filter(country == input$country) %>% 
        ggplot() +
            aes(x = N, y = medal, fill = medal) +
            geom_col() +
            facet_wrap(~country) +
            theme_minimal() +
            scale_fill_manual(values = c("#AD7C42", "#D4D2C7", "#E4CC08"))
    )
}

shinyApp(ui, server)
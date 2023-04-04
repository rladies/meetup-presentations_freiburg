library(shiny)
library(tidyverse)
library(gt)

ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "united"),
  titlePanel("Pride!"),
  fluidRow(
    column(4, 
           selectInput(
             inputId = "selected_company",
             label = "Company:",
             choices = c("Amazon", "American Electric Power", "AT&T", "Berkshire Hathaway", "Charter Communications", "Comcast", "Enterprise Products Partners", "FedEx", "State Farm", "Tenet Healthcare", "Toyota", "Union Pacific", "UnitedHealth Group", "Valero Energy", "Vistra")
           )
    ),
    column(8, 
           tableOutput("pride_table")
    )
  ),
  
  fluidRow(
    column(4, 
           selectInput(
             inputId = "plot_axis",
             label = "Metric:",
             choices = c("Total donation (USD)" = "USD",
                         "Politicians donated to" = "Politicians",
                         "States donated in" = "States")
           )
    ),
    column(8, 
           plotOutput("pride_plot")
    )
  )
)

server <- function(input, output, session) {
  thematic::thematic_shiny()
  pride <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-06-07/static_list.csv') %>% 
    rename(
      "Pride" = "Pride?",
      "HRC" = "HRC Business Pledge",
      "USD" = "Amount Contributed Across States",
      "Politicians" = "# of Politicians Contributed to",
      "States" = "# of States Where Contributions Made"
    ) %>% 
    filter(Company != "Grand Total") %>% 
    top_n(15, USD)
  
  output$pride_table <- renderTable(
    pride %>% 
      filter(Company == input$selected_company) %>% 
      select(-hex) %>% 
      gt() %>% 
      fmt_currency(
        columns = USD,
        currency = "USD"
      ) 
  )
  
  pride$hex <- rep(c("B", "C", "D", "E", "F", "G"), length.out = 15)
  
  output$pride_plot <- renderPlot(
    pride %>% 
    mutate(hex = ifelse(Company == input$selected_company, "AA", hex)) %>% 
    ggplot(aes(x = .data[[input$plot_axis]], y = reorder(Company, .data[[input$plot_axis]]), fill = hex)) +
    geom_col(show.legend = FALSE) +
    scale_fill_manual(values = c("yellow", "#fb9b53", "#d464a4", "#eb7323", "#b35393", "#d42c04", "#a40464")) +
    labs(y = NULL) +
    theme_minimal()
  )
}

shinyApp(ui, server)

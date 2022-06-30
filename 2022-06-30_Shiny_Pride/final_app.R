library(shiny)
library(tidyverse)
library(gt)

ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "journal"),
  titlePanel(
    "Is your favorite company donating to anti-LGBTQIA* law-makers?"
  ),
  
  fluidRow(
    column(4, 
           selectInput(
             inputId = "table_company",
             label = "Company:",
             choices = c("Amazon", "American Electric Power", "AT&T", "Berkshire Hathaway", "Charter Communications", "Comcast",                     
                         "Enterprise Products Partners", "FedEx", "State Farm", "Tenet Healthcare", "Toyota", "Union Pacific",           
                         "UnitedHealth Group", "Valero Energy", "Vistra")
           )
    ),
    column(8, 
           tableOutput("company_table")
    )
  ),
  
  fluidRow(
    column(4, 
           selectInput(
             inputId = "show_plot",
               label = "Show:",
               choices = c("Total donation" = "USD",
                          "Politicans donated to" = "Politicians",
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
  
  output$company_table <- renderTable(
    pride %>% 
      filter(Company == input$table_company) %>% 
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
       mutate(hex = ifelse(Company == paste(input$table_company), "AA", hex)) %>% 
       ggplot(aes(x = .data[[input$show_plot]], y = reorder(Company, .data[[input$show_plot]]), fill = hex)) +
       geom_col(show.legend = FALSE) +
       scale_fill_manual(values = c("yellow", "#fb9b53", "#d464a4", "#eb7323", "#b35393", "#d42c04", "#a40464")) +
       labs(y = NULL) +
       theme_minimal()
  )
  
 
  
}

shinyApp(ui, server) 

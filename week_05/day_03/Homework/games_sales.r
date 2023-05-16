#source("librarys.R")
library(tidyverse)

game_data <- CodeClanData::game_sales

publishers <- game_data %>% 
  distinct(publisher) %>% 
  pull()

genre <- game_data %>% 
  distinct(genre) %>% 
  pull()

ui <- fluidPage(
 # theme = bs_theme(bg = "white", fg = "#ff0123", base_font = font_google("Dongle", local = TRUE)),
  titlePanel("Sales by Publisher and Genre"),
  tabsetPanel(
    tabPanel(title = "Select parameters",
             fluidRow(
               selectInput(
                 inputId = "publisher_input",
                 label = "Select a Publisher",
                 choices = publishers
               ),
               pickerInput(
                 inputId = "genre_input",
                 label = "Select a Genre",
                 choices = genre,
                 options = list(`actions-box` = TRUE),
                 multiple = TRUE,
                 selected = "Puzzle"
               )
             )
    ),
    tabPanel( title = "Output",
      column(
        width = 6,
        offset = 2,
        plotOutput("publisher_out")
      )
    )
    
  )
)  
server <- function(input, output, session) {
  
  output$publisher_out <- renderPlot(game_data %>% 
    filter(publisher == input$publisher_input,
           genre %in% input$genre_input) %>% 
    ggplot(aes(x = year_of_release, y = sales, fill = critic_score)) + 
    geom_col()+
    scale_fill_gradient(low = "saddlebrown", high = "turquoise1") +
    scale_x_continuous(breaks = 1988:2016) +
    labs(x = "Year of Release",
         y = "Sales in Millions")
  )
  
  
}

shinyApp(ui, server)
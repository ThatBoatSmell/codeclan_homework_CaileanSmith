library(shiny)
source("library_data.R")

# WARNING: THIS LOADS VERY SLOWLY DUE TO THE SIZE OF THE DATASET
# I'd slim it down, but I want to build around the whole dataset later

# The goal of this app is to look at types of monster cards, then calculate their average stat
# total (attack + defence) and plot them by year.
# This allows the user to see how stat-lines have developed over time - What was the average stats of 
# a fire normal monster in 2000 vs now?

# Ideally, i'd like to compare other values (e.g length of card effect)

ui <- fluidPage(
  titlePanel("Yu-gi-oh Card data looker-atter"),
  titlePanel("But so far all it compares is average stat totals(atk+def) by Year"),
  tabsetPanel(
    tabPanel(
      title = "Select Parameters",
      fluidRow(
        column(
          width = 4,
          radioButtons(
            # These buttons are for selecting a region for the purposes of comparing release year
            # as the OCG and TCG have different release dates for certain things
            inputId = "region_input",
            label = "Select Region",
            choices = c("OCG", "TCG")
          )
        ),
        column(
          width = 4,
          selectInput(
            inputId = "attribute_input",
            label = "Select Monster Attribute",
            choices = unique(cards_wide$attribute)
          )
        )
      ),
      fluidRow(
        selectInput(
          inputId = "monster_input",
          label = "Select Monster Card Type",
          choices = monster_choices
        )
      )
    ),
    tabPanel(
      title = "output",
      plotOutput("output_plot")
    )
  )
)


server <- function(input, output, session) {
  
  # 
  
  filtered_if <- eventReactive(eventExpr = input$region_input,
                               valueExpr = {
    if (input$region_input == "OCG")
    cards_wide %>% 
    mutate(release_year = as.numeric(format(ymd(ocg_release),'%Y'))) %>% 
    group_by(release_year) 
  else 
    cards_wide %>%
    mutate(release_year = as.numeric(format(ymd(tcg_release),'%Y'))) %>% 
    group_by(release_year)
  })
  output$output_plot<- renderPlot({ 
    filtered_if() %>% 
      filter(attribute == input$attribute_input) %>% 
      mutate(avg_stat_total_by_year = floor(mean(stat_total))) %>% 
      ggplot(aes(x = release_year, y = avg_stat_total_by_year , 
                 colour = input$attribute_input,
                 shape = input$attribute_input)) +
      geom_line() +
      geom_point()
  })            
}

shinyApp(ui, server)
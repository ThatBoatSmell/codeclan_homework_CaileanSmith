library(shiny)
source("library_data.R")
source("theme.R")

# WARNING: THIS LOADS VERY SLOWLY DUE TO THE SIZE OF THE DATASET
# I'd slim it down, but I want to build around the whole dataset later

# The goal of this app is to look at types of monster cards, then calculate their average stat
# total (attack + defence) and plot them by year.
# This allows the user to see how stat-lines have developed over time - What was the average stats of 
# a fire normal monster in 2000 vs now?

# Ideally, i'd like to compare other values (e.g length of card text)

ui <- fluidPage(
  # This theme and image section is attempting to emulate the site where the data set was taken
  # For this, may need to make a grid to align the text between the two flames using actual HTML/CSS
  theme = bslib_boys_theme,
  fluidRow(
    titlePanel(
      
       
      
      title = "Yu-gi-oh Card data looker-atter"),
   img(src = "fire.gif",align = "left", style = "width: 75px"),
    img(src = "fire.gif", style = "width: 75px")
        
      ),
 # titlePanel("Yu-gi-oh Card data looker-atter"),
 fluidRow(
  titlePanel("But so far all it compares is average stat totals(atk+def) by Year")
  ),
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
          # I want to make a multiple selection input, but the graphs would not display correctly
          # Will need to correct 
          selectInput(
            inputId = "attribute_input",
            label = "Select Monster Attribute",
            choices = attribute_list
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
  
  # This creates a new column based on the region the user selected, 
  # which supplies the Year a card was released in said Region
  # It then groups by this newly created column so it can be used
  # for plotting the line chart
  
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
      filter(type %in% input$monster_input) %>% 
      filter(attribute %in% input$attribute_input) %>% 
      mutate(avg_stat_total_by_year = floor(mean(stat_total))) %>% 
      arrange(attribute) %>% 
      ggplot(aes(x = release_year, y = avg_stat_total_by_year)) +
      geom_line(aes(colour = attribute)) +
      geom_point(aes(shape = attribute)) +
      labs(
        title = "Average stat total by release year",
        x = "Release Year",
        y = "Average ATK + DEF") +
      theme_bw()
      
  })            
}

shinyApp(ui, server)
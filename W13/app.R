
library(shiny)

# Install and load required packages
if (!requireNamespace("shiny", quietly = TRUE)) {
  install.packages("shiny")
}
library(shiny)
library(ggplot2)
library(dplyr)

# Load data
data <- read.csv("NM2207 Updated Data.csv")

# Define UI for the Shiny app
ui <- fluidPage(
  titlePanel("Find Difference in Gender LFPR"),
  sidebarLayout(
    sidebarPanel(
      selectInput("selectedYear", "Select Year:", choices = unique(data$X)),
      actionButton("calculateButton", "Calculate Difference"),
      hr(),
      h4("Difference:"),
      textOutput("genderDifference")
    ),
    mainPanel(
      plotOutput("linePlot")
    )
  )
)

# Define server logic for the Shiny app
server <- function(input, output) {
  output$linePlot <- renderPlot({
    # Create a ggplot2 line plot
    ggplot(data, aes(x = X)) +
      geom_line(aes(y = Male.LFPR, color = "Male Labor Force Participation Rate")) + 
      geom_line(aes(y = Female.LFPR, color = "Female Labor Force Participation Rate")) +
      labs(
        title = "Trends in Labor Force Participation Rates in India",
        x = "Year",
        y = "Labor Force Participation Rate (%)"
      ) +
      theme_minimal() +
      theme(
        legend.position = "bottom"
      )
  })
  
  # Calculate difference based on user input
  observeEvent(input$calculateButton, {
    selected_year <- input$selectedYear
    
    # Filter data based on user input
    filtered_data <- data[data$X == selected_year, ]
    
    # Calculate the difference in labor force participation rates
    gender_diff <- filtered_data$Male.LFPR - filtered_data$Female.LFPR
    
    # Update output value with percentage sign
    output$genderDifference <- renderText(paste("Difference: ", round(gender_diff, 2), "%"))
  })
}

# Run the Shiny app
shinyApp(ui, server)

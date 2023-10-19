library(shiny)

# Define UI with customizations ----
ui <- fluidPage(
  titlePanel("Customized Real-Time Clock with Date"),
  sidebarLayout(
    sidebarPanel(
      p("Customize the clock display:"),
      selectInput("clock_format", "Clock Format:", 
                  choices = c("24-hour" = "%H:%M:%S", "12-hour" = "%I:%M:%S %p"), selected = "%H:%M:%S"),
      sliderInput("update_interval", "Update Interval (seconds):", min = 1, max = 10, value = 1)
    ),
    mainPanel(
      h1(textOutput("current_time", container = span)),
      h2(textOutput("current_date", container = span))
    )
  )
)

# Define server logic with customizations ----
server <- function(input, output, session) {
  output$current_time <- renderText({
    invalidateLater(input$update_interval * 1000, session)
    format(Sys.time(), input$clock_format)
  })
  
  output$current_date <- renderText({
    format(Sys.Date(), "%A, %B %d, %Y")
  })
}

# Create the Shiny app with customizations ----
shinyApp(ui, server)

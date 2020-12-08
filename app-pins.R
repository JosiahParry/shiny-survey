#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)

cran_pkgs <- readr::read_rds("pkgs.rds")

pins::board_register_rsconnect(server = Sys.getenv("CONNECT_SERVER"),
                               key = Sys.getenv("CONNECT_API_KEY"))

# Define UI for application that draws a histogram
ui <- fluidPage(

  column(3,
         textInput(
           inputId = "name",
           label = "Enter your name:",
           value = "Josiah",
           placeholder = "Your name here"),
         sliderInput(
           inputId = "r_affinity",
           label = "How much do you love R?",
           min = 1,
           max = 5,
           value = 3,
           ticks = FALSE,
           step = 1
         ),
         selectInput(inputId = "fav_pkg",
                     label = "What's your favorite CRAN package?",
                     choices = cran_pkgs,
                     selected = "genius"),
         actionButton("submit", "Submit")
  ),

  column(6, tableOutput("results"))

)

# Define server logic required to draw a histogram
server <- function(input, output, session) {

  # Change the button appearance if it has been clicked
  observeEvent(input$submit, {
    updateActionButton(session, "submit",
                       label = "Thanks!")
  })

  results_tibble <- reactive({

    tibble::tibble(
      name = input$name,
      r_affinity = input$r_affinity,
      fav_pkg = input$fav_pkg
    )

  })

  output$results <- renderTable(results_tibble())


  observeEvent(input$submit, {

    # write to database -------------------------------------------------------

    # if statement prevents multiple submissions.

    if (input$submit == 1) {

      to_insert <- data.frame(
        name = input$name,
        r_affinity = input$r_affinity,
        fav_pkg = input$fav_pkg
      )
      # get the current pinned object, bind the row to it, pin again
      pins::pin_get("josiah/fav-pkg", board = "rsconnect") %>%
        bind_rows(to_insert) %>%
        pins::pin("fav-pkg", board = "rsconnect")


    }

  })


}

# Run the application
shinyApp(ui = ui, server = server)

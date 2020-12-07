#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

cran_pkgs <- readr::read_rds("pkgs.rds")


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

    # Leaves goButton3's icon, if it exists,
    # unchaged and changes its label

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

        if (input$submit == 1) {
            con <- DBI::dbConnect(RSQLite::SQLite(), "fav-pkg.sqlite")
            to_insert <- list(
                name = input$name,
                r_affinity = input$r_affinity,
                fav_pkg = input$fav_pkg
            )
            insert_statement <- RSQLite::dbSendStatement(con,
            "INSERT INTO results (name, r_affinity, fav_pkg)
            VALUES(:name, :r_affinity, :fav_pkg);",
            params = to_insert
            )

            DBI::dbDisconnect(con)
        }

    })


}

# Run the application
shinyApp(ui = ui, server = server)

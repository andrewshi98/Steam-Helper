library(shiny)
library(knitr)

#source("Project Description.rmd")

project_description_server <- function(input, output) {
  output$markdown <- renderUI({
    about.file <- file("scripts/about.html", "r")
    about.file.text <- readLines(about.file)
    close(about.file)
    HTML(about.file.text)
  })
}

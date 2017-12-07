library(shiny)
library(knitr)

#source("Project Description.rmd")

project_description_server <- function(input, output) {
  output$markdown <- renderUI({
    HTML(markdown::markdownToHTML(knit('Project Description.rmd', quiet = TRUE)))
  })
}

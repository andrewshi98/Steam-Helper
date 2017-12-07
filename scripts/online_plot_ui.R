library(shiny)

# This is a example of what your ui scripts should look like.
# Please follow syntax so it makes our collaboration easier.

OnlinePlotUI <- function(){
  return (tabPanel("Online History",
                   #You do exactly the same thing as you would in the ui.R file
                   fluidPage(
                     titlePanel("Steam Player Online History"),
                     fluidRow(plotlyOutput("onlineplot", height = "auto", width = "auto"))
                     )
                   )
  )
}

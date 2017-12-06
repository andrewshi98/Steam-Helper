library(shiny)
library(ggiraph)

# This is a example of what your ui scripts should look like.
# Please follow syntax so it makes our collaboration easier.

MainPageUI <- function(){
  return (tabPanel("Main Page",
                   #You do exactly the same thing as you would in the ui.R file
                   fluidPage(
                     theme = "main.css",
                       fluidRow(ggiraphOutput("realtimegraph", height = "auto", width = "auto")),
                    sidebarPanel(sliderInput("sides", "Number of edges:",
                                              min = 0, max = 25, value = 6), width = 12),
                       fluidRow(dataTableOutput("realtimetable"))
                  )
                  )
          )
}

library(shiny)

source("scripts/detail_page_script.R")

DetailPageUI <- function(){
  return (tabPanel("Game Detail",
                   tags$head(tags$script(src="game_detail.js")),
                   #You do exactly the same thing as you would in the ui.R file
                   fluidPage(
                     column(3, align="center",
                            selectInput("select", label = "Choose A Game",
                                        choices = GetGameOptionList(),
                                        selected = 1)
                     ),
                     htmlOutput("text")
                   )
  )
  )
}

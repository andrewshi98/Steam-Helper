RandomGameUI <- function(){
  return (
    tabPanel(
      "Random Game Generator",
      fluidPage(theme = "main.css", fluidRow(dataTableOutput("randomgametable"))),
      actionButton("randomize", "Randomize Game")
    )
  )
}
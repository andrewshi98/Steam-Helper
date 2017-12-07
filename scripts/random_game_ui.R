RandomGameUI <- function(){
  return (
    tabPanel(
      "Random Game Generator",
      actionButton("randomize", "Randomize Game"),
      fluidPage(theme = "main.css", fluidRow(dataTableOutput("randomgametable")))
    )
  )
}
library(shiny)

GetDataRowOption <- function(){
  option.list <- colnames(game.data.raw)
  option.list <- option.list[(5:length(option.list))]
  option.list.name <- gsub("_", " ", option.list)
  option.list.name <- gsub("(?<=\\b)([a-z])", "\\U\\1", option.list.name, perl=TRUE)
  names(option.list.name) <- option.list.name
  return (option.list.name)
}

CustomGraphUI <- function(){
  return (tabPanel("Custom Graph",
                   #You do exactly the same thing as you would in the ui.R file
                     sidebarPanel({selectInput("selectX", label = "Choose X Axis",
                                                choices = GetDataRowOption(),
                                                selected = "Score Rank")},
                                  {selectInput("selectY", label = "Choose Y Axis",
                                               choices = GetDataRowOption(),
                                               selected = "Positive")}),
                     mainPanel(plotlyOutput("customgraph"))
  )
  )
}

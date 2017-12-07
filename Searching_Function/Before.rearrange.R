# Searching UI by Yuanrui Zhang

library(shiny)

fluidPage(
  #selectInput('text',  label = h2("Search by Name"),as.character(steam_data$name), multiple=TRUE, selectize=TRUE),
  uiOutput('searchBar'),
  
  hr(),
  titlePanel("Basic Info"),
  fluidRow(column(4,  tableOutput("basic.info"))),
  
  helpText('price - US price in cents.'),
  
  titlePanel("Player info: recent 2 weeks"),
  fluidRow(column(4,  tableOutput("two.weeks"))),
  
  titlePanel("Player info: overall"),
  fluidRow(column(4,  tableOutput("forever"))),
  
  mainPanel(
    uiOutput('imageforUI', align = "center"),
    htmlOutput('discription', escape = FALSE)
  ),
  
  htmlOutput('supported_languages'),
  
  textOutput('genres')
  
  #textOutput
  #verbatimTextOutput
)

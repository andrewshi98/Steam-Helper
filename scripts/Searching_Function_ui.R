# Searching UI by Yuanrui Zhang

library(shiny)

Searching_Function_UI<-function(){
  return(fluidPage( 
  tabsetPanel(
    tabPanel("Search by Name",
      uiOutput('searchBar'),
  
      hr(),

      sidebarLayout(
       sidebarPanel(
         h3("Game Description"),
          htmlOutput('detailed_description', escape = FALSE),
          h3("genres"),
          textOutput('genres')
          ),
    
    mainPanel(
      uiOutput('imageforUI', align = "center"),
      helpText('Click image for redirecting to steam shop page',align = "center")
      #htmlOutput('supported_languages')

    )
    
  ),
  
  h3("Basic Info"),
  fluidRow(column(12,  tableOutput("basic.info"))),
  helpText('price - US price in cents.'),
  
  h3("Player Info: Recent 2 Weeks"),
  fluidRow(column(12,  tableOutput("two.weeks"))),
  #helpText('last two columns stands for gaming time in minute.'),

  h3("Player Info: Recent 2 Weeks"),
  #titlePanel("Player Info: Overall"),
  fluidRow(column(12,  tableOutput("forever")))
  
  #textOutput
  #verbatimTextOutput
    ),
  tabPanel("Search by Developer",
           uiOutput('searchBar.Developer'),
           sliderInput("ratings",
                       "scope the ratings:",
                       min = 0,
                       max = 100,
                       value = c(0,100)),
           
           
           hr(),
           
           h3("Basic Info"),
           fluidRow(column(12,  tableOutput("basic.info.developer"))),
           helpText('price - US price in cents.')
    )
  )
))}

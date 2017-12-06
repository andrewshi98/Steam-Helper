library(shiny)

# Source your files in this section
library("jsonlite")
library('dplyr')
##Andrew
source("scripts/main_page_server.R")
##
steam_data <- read_json('data/game_data.json')
max.length <- max(sapply(steam_data, length))
steam_data <- lapply(steam_data, function(v) { c(v) })
steam_data <- do.call(rbind, steam_data)
steam_data <- data.frame(steam_data)
row.names(steam_data) <- NULL

steam_data <- steam_data[steam_data$name != "",]


MainPageUI <- function(input, output){
  random.game <- sample_n(steam_data, 1) %>% 
    select(name, developer, publisher, score_rank, userscore)

  return (tabPanel("Random Game",
                   #You do exactly the same thing as you would in the ui.R file
                   
          output$table <- renderDataTable(random.game)
  ) 
  )
}







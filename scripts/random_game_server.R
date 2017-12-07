# Source your files in this section
library(jsonlite)
library(shiny)
library(ggplot2) 
library(packcircles)
library(viridis)
library(ggiraph)
library(dplyr)
library(DT)
library(XML)
##Andrew
#source("scripts/main_page_server.R")
##


RandomGameTable <- function(){
  steam_data <- read_json('data/game_data.json')
  max.length <- max(sapply(steam_data, length))
  steam_data <- lapply(steam_data, function(v) { c(v) })
  steam_data <- do.call(rbind, steam_data)
  steam_data <- data.frame(steam_data)
  row.names(steam_data) <- NULL
  
  steam_data <- steam_data[steam_data$name != "",]
  
  random.game.table <- sample_n(steam_data, 1) %>% 
    select(name, developer, publisher, score_rank, userscore) %>% 
      datatable(escape = FALSE, style = "bootstrap")
  return (random.game.table)
}

RandomGamePage_Server <- function(input, output){
  output$randomgametable <- renderDataTable({RandomGameTable()})
  observeEvent(input$randomize, {
    output$randomgametable <- renderDataTable({RandomGameTable()})
  })
}

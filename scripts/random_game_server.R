#libraries
library(jsonlite)
library(shiny)
library(ggplot2) 
library(packcircles)
library(viridis)
library(ggiraph)
library(dplyr)
library(DT)
library(XML)

RandomGameTable <- function(){
  #reading in the json data and converting it to a dataframe to read in
  steam_data <- read_json('data/game_data.json')
  max.length <- max(sapply(steam_data, length))
  steam_data <- lapply(steam_data, function(v) { c(v) })
  steam_data <- do.call(rbind, steam_data)
  steam_data <- data.frame(steam_data)
  steam_data <- steam_data[steam_data$name != "",]
  #removing the row names
  row.names(steam_data)<-NULL
  
  #matching every name with their appid to make a hyperlink that will send you to the steam store
  steam_data$name <- paste0('<a href= http://store.steampowered.com/app/', steam_data$appid,'>',steam_data$name, '<a/>')
  
  #renaming columns for better style and understanding
  steam_data_m <- rename(steam_data, Name = name, Developer = developer,
                       Publisher = publisher, CriticScore = score_rank,
                       UserScore = userscore)
  
  #takes in the steam_data frame then selects 10 random rows, selects only name, 
  #publisher, developer, score_rank and userscore into the printed data
  random.game.table <- sample_n(steam_data_m, 10) %>% 
    select(Name, Developer, Publisher, CriticScore, UserScore) %>% 
    datatable(escape = FALSE, style = "bootstrap", rownames = FALSE)
  return (random.game.table)
}

#this funciton will be called within the main server page, this calls the table then
#when the action button is pressed it reloads the previous function to keep the styling correct
RandomGamePage_Server <- function(input, output){
  output$randomgametable <- renderDataTable(RandomGameTable(), escape = FALSE)
  observeEvent(input$randomize, {
    output$randomgametable <- renderDataTable(RandomGameTable(), escape = FALSE)
  })
}

  
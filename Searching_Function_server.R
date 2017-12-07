library("httr")
library("jsonlite")
library("dplyr")
library("data.table")



steam_data<-read_json('data/game_data.json')
max.length <- max(sapply(steam_data, length))
steam_data <- lapply(steam_data, function(v) { c(v, rep(NA, max.length-length(v)))})
steam_data<- do.call(rbind, steam_data)
steam_data<- data.frame(steam_data)
rownames(steam_data)<-NULL
steam_data<- steam_data[steam_data$name != "",] 


GameSearch <- function(game.name){
  
  test1<- filter(steam_data, name %in% game.name) 
  return(test1)
}

GameSearch("Dota 2")
GameSearch("")
  
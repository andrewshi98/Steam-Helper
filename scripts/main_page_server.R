library(shiny)
library(ggplot2) 
library(packcircles)
library(viridis)
library(ggiraph)
library(dplyr)
library(DT)

source("scripts/data_renewer.R")

RegulateName <- function(data){
  for (i in (1:length(data)))
  {
    if(nchar(data[i])>10){
      if(nchar(strsplit(data[i], " ")[[1]][1]) < 4){
        data[i] <- sub(" ", "-!", data[i])
        data[i] <- sub(" ", "\n", data[i])
        data[i] <- sub("-!", " ", data[i])
      }else{
        data[i] <- sub(" ", "\n", data[i])
      }
    }
  }
  return (data)
}

GenerateCurrentGraph <- function(input, output){
  game.player <- read.csv("data/RealtimeUser.csv", stringsAsFactors = FALSE)
  game.player$textsize <- (game.player$Current.Player^1.5)/nchar(game.player$Name)^1.5
  game.player$regulatedname <- RegulateName(game.player$Name)
  
  packing <- circleProgressiveLayout(game.player$Current.Player, sizetype='area')
  game.player <- cbind(game.player, packing)
  dat.gg <- circleLayoutVertices(packing, npoints=as.numeric(input$sides))
  
  hover.text <- sprintf("%s\nCurrent Player: %s\nDaily Peak: %s", gsub("'", " ", game.player$Name),
                        game.player$Current.Player,
                        game.player$Peak.Player) 
  
  # Make the plot with a few differences compared to the static version:
  plot<-ggplot() + 
    geom_polygon_interactive(data = dat.gg, aes(x, y, group = id, fill = as.factor(id),
                                                tooltip = hover.text[id]),
                             colour = "black", alpha = 0.75, show.legend = FALSE) +
    geom_text(data = game.player, aes(x, y, size= textsize,
                                      label = regulatedname)) +
    scale_size_continuous(range = c(0.5, 7)) +
    
    # General theme:
    theme_void() + 
    theme(legend.position="none") +
    coord_equal()
  widg=ggiraph(ggobj = plot)
  return(widg)
}

#Reading real time table

RealtimeTable <- function(){
  game.player <- read.csv("data/RealtimeUser.csv", stringsAsFactors = FALSE) %>% 
    mutate(Name = sprintf('<a href="%s">%s</a>', Link, Name)) %>% 
    select(-Link)
  game.player.table <- datatable(game.player, escape = FALSE, style = 'bootstrap') %>% 
    formatStyle(1, color = 'black')
  
  return (game.player.table)
}

RemoveList <- function(data) {
  for (i in (1:ncol(data))){
    if(length(data[, i]) == length(unlist(data[, i]))){
      data[, i] <- unlist(data[, i])
    }
  }
  return (data)
}

#Function that extract data

data_frame_extraction<-function(){
  steam_data<-jsonlite::fromJSON("data/game_data.json")
  max.length <- max(sapply(steam_data, length))
  steam_data <- lapply(steam_data, function(v) { c(v, rep(NA, max.length-length(v)))})
  steam_data<- do.call(rbind, steam_data)
  steam_data<- data.frame(steam_data, stringsAsFactors = FALSE)
  rownames(steam_data)<-NULL
  steam_data <- RemoveList(steam_data)
  steam_data$price[steam_data$price=="NULL"]<-"1"
  steam_data$price[steam_data$price=="0"]<-"1"
  steam_data$price<-unlist(steam_data$price)
  steam_data$price<-as.numeric(steam_data$price)
  return(steam_data)
}

MainPage_Server <- function(input, output){
  RenewCheck_MainPage()
  game.data.raw <<- data_frame_extraction()
  output$realtimegraph <- renderggiraph({GenerateCurrentGraph(input, output)})
  output$realtimetable <- DT::renderDataTable({RealtimeTable()})
}
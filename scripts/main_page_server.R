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
    scale_size_continuous(range = c(0.5, 8)) +
    
    # General theme:
    theme_void() + 
    theme(legend.position="none") +
    coord_equal()
  widg=ggiraph(ggobj = plot)
  return(widg)
}

RealtimeTable <- function(){
  game.player <- read.csv("data/RealtimeUser.csv", stringsAsFactors = FALSE) %>% 
    mutate(Name = sprintf('<a href="%s">%s</a>', Link, Name)) %>% 
    select(-Link)
  game.player.table <- datatable(game.player, escape = FALSE) %>% 
    formatStyle("Name", backgroundColor = styleInterval(3.4, c('gray', 'white')))
  return (game.player.table)
}

MainPage_Server <- function(input, output){
  RenewCheck()
  output$realtimegraph <- renderggiraph({GenerateCurrentGraph(input, output)})
  output$realtimetable <- DT::renderDataTable({RealtimeTable()})
}
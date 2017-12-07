library(shiny)
library(jsonlite)
library(dplyr)
library(tidyr)
library(plotly)
library(httr)

# Source your files in this section

##
source("scripts/main_page_server.R")
##

#

returnlist <- function(search=''){
  
  GetGameOptionList <- function(){
    game.data.file <- file("data/game_data.json", "r")
    game.data <- jsonlite::fromJSON(readLines(game.data.file))
    close(game.data.file)
    game.data <- data.frame(do.call(rbind, game.data), stringsAsFactors = FALSE)
    
    option.list <- as.vector(unlist(game.data$appid))
    names(option.list) <- as.vector(unlist(game.data$name))
    
    detail_page_game.data <<-  game.data
    
    return (option.list)
  }
  
  RemoveList <- function(data) {
    for (i in (1:ncol(data))){
      if(length(data[, i]) == length(unlist(data[, i]))){
        data[, i] <- unlist(data[, i])
      }
    }
    return (data)
  }
  
  data_frame_extraction()
  steam_data<-data_frame_extraction()
  steam_data<-arrange(steam_data,name)%>%
    arrange(desc(userscore))%>%
    arrange(price)
  steam_data<-steam_data[-c(15777:15814),]
  steam_data$price<-steam_data$price/100
  
  #Styling
  labelfont <- list(
    color = "rgb(255, 255, 255)"
  )
  
  xstyle = list(title = "Date",
                gridcolor = 'rgb(150,150,150)',
                showgrid = TRUE,
                showline = FALSE,
                showticklabels = TRUE,
                tickcolor = 'rgb(127,127,127)',
                ticks = 'outside',
                zeroline = FALSE,
                titlefont = labelfont,
                tickcolor = toRGB("white"),
                tickfont = list(color = "rgb(255, 255, 255)"))
  ystyle = list(title = "Steam User",
                gridcolor = 'rgb(150, 150, 150)',
                showgrid = TRUE,
                showline = FALSE,
                showticklabels = TRUE,
                tickcolor = 'rgb(127,127,127)',
                ticks = 'outside',
                zeroline = FALSE,
                titlefont = labelfont,
                tickfont = list(color = "rgb(255, 255, 255)"))
  
  q <- steam_data %>%
    plot_ly(
      x = ~price, 
      y = ~userscore, 
      size = ~userscore, 
      color = ~userscore, 
      frame = steam_data$price, 
      text = paste0(steam_data$name,'<br>User Score: ',steam_data$userscore,", ",'<br>Price: ', steam_data$price),
      hoverinfo = "text",
      type = 'scatter',
      mode = 'markers'
    ) %>%
    layout(
      xaxis = list(
        type = "log"
      )
    )%>% 
    animation_opts(
      50, easing = "elastic", redraw = FALSE
    ) %>% 
    animation_button(
      x = 1, xanchor = "right", y = 0, yanchor = "bottom"
    ) %>%
    animation_slider(
      currentvalue = list(prefix = "Price: ", font = list(color="orange"))
    )%>%
    layout(
      title = "User Score vs. Price",
      xaxis = list(title = "Game price"),
      yaxis = list(title = "User Score")
      #margin = list(l = 200)
    )%>%
    layout(paper_bgcolor='rgba(50, 50, 50, 80)', plot_bgcolor='rgba(100, 100, 100, 50)',
               xaxis = xstyle, yaxis = ystyle, font = list(color = "white"))
  return(q) 
}

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

return3dplot<-function(search=''){
  
  RemoveList <- function(data) {
    for (i in (1:ncol(data))){
      if(length(data[, i]) == length(unlist(data[, i]))){
        data[, i] <- unlist(data[, i])
      }
    }
    return (data)
  }
  
  data_frame_extraction()
  steam_data<-data_frame_extraction()
  steam_data$average_forever<-steam_data$average_forever/60
  steam_data<-arrange(steam_data,name)%>%
    arrange(desc(userscore))%>%
    arrange(owners)%>%
    arrange(average_forever)
  
  steam_data<-steam_data[-c(15777:15814),]
  
  colors <- c('#4AC6B7', '#1972A4', '#965F8A', '#FF7070', '#C61951')
  
  
  #Styling
  labelfont <- list(
    color = "rgb(255, 255, 255)"
  )
  
  xstyle = list(title = "Date",
                gridcolor = 'rgb(150,150,150)',
                showgrid = TRUE,
                showline = FALSE,
                showticklabels = TRUE,
                tickcolor = 'rgb(127,127,127)',
                ticks = 'outside',
                zeroline = FALSE,
                titlefont = labelfont,
                tickcolor = toRGB("white"),
                tickfont = list(color = "rgb(255, 255, 255)"))
  ystyle = list(title = "Steam User",
                gridcolor = 'rgb(150, 150, 150)',
                showgrid = TRUE,
                showline = FALSE,
                showticklabels = TRUE,
                tickcolor = 'rgb(127,127,127)',
                ticks = 'outside',
                zeroline = FALSE,
                titlefont = labelfont,
                tickfont = list(color = "rgb(255, 255, 255)"))
  
  p <- plot_ly(steam_data, x = ~average_forever, y = ~owners, z = ~userscore,
               text=paste0('Name: ',steam_data$name,'<br>No. of Players: ', steam_data$owners,'<br>User Score ',steam_data$userscore),
               marker = list(color = ~userscore, colors = colors, showscale = TRUE), hoverinfo = "text") %>%
    add_markers() %>%
<<<<<<< HEAD
    layout(scane=list(title="3D Game User Data",
=======
    layout(scene= list(title="3D Game User Data",
>>>>>>> 605dc6926b8eef06ac927adae9f0896877d99998
                        xaxis = list(title = 'Avg. hours played since 2009'),
                        yaxis = list(title = 'No. of players'),
                        zaxis = list(title = 'User Score')),
           annotations = list(
             x = 1.13,
             y = 1.05,
             text = 'User Score',
             xref = 'paper',
             yref = 'paper',
             showarrow = FALSE
           )
           ) %>%
    layout(paper_bgcolor='rgba(50, 50, 50, 80)', plot_bgcolor='rgba(100, 100, 100, 50)',
           xaxis = xstyle, yaxis = ystyle, font = list(color = "white"))
return(p)
}

Charts_Server<-function(input, output){
  
  output$scatter <- renderPlotly({ 
    return(returnlist(input$search))
  })
  output$scatter3d <- renderPlotly({
    return(return3dplot(input$search))
  })
}

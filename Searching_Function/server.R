library("httr")
library("jsonlite")
library("dplyr")
library("data.table")

setwd('~/Desktop/INFO201/repo/Steam-Helper/')

#read steam_data
steam_data<-read_json('data/game_data.json')
max.length <- max(sapply(steam_data, length))
steam_data <- lapply(steam_data, function(v) { c(v, rep(NA, max.length-length(v)))})
steam_data<- do.call(rbind, steam_data)
steam_data<- data.frame(steam_data, stringsAsFactors = FALSE)
rownames(steam_data)<-NULL
#remove game with no name
steam_data<- steam_data[steam_data$name != "",] 



more.steam.data<- function(id.number, option){
  base.url<-('http://store.steampowered.com/api/appdetails')
  parameter <- list(appids = id.number)
  response<-GET(base.url, query = parameter)
  body<-content(response,"text")
  parsed.data<- fromJSON(body)
  
  if(option == "short_description"){
    return (parsed.data[[1]]$data$short_description)
  }else if(option == "genres"){
    return (parsed.data[[1]]$data$genres)
  }else if(option == "supported_languages"){
    return (parsed.data[[1]]$data$supported_languages)
  }else if(option == "website"){
    return (parsed.data[[1]]$data$website)
  }
}

function(input, output) {
  
  

    
  
  output$basic.info <- renderTable({ 
    
    filter(steam_data, name %in% input$text) %>% 
      select(name, developer, publisher, owners, owners_variance,score_rank, positive,negative, price) # Rank,
    })
  
  output$two.weeks <- renderTable({ 
    
    filter(steam_data, name %in% input$text) %>% 
      select(name,players_2weeks,players_2weeks_variance,average_2weeks,median_2weeks)
  })
  
  output$forever <- renderTable({ 
    
    filter(steam_data, name %in% input$text) %>% 
      select(name,players_forever,players_forever_variance,average_forever,median_forever)
  })

  
  output$searchBar = renderUI({
    selectInput('text', label = h2("Search by Name"), as.character(steam_data$name),multiple=FALSE, selectize=TRUE)
  })
 

  output$imageforUI = renderUI({
    get.appId<-as.numeric(filter(steam_data, name %in% input$text)$appid)
    display<-tags$img(src = sprintf("http://cdn.edgecast.steamstatic.com/steam/apps/%s/header.jpg", get.appId))
    a(href=sprintf("http://store.steampowered.com/app/%s/",get.appId), display)
  
  })
  
  output$discription = renderText({
    
    get.appId<-as.numeric(filter(steam_data, name %in% input$text)$appid)
    more.steam.data(get.appId,"short_description")
  })
  
  output$supported_languages = renderText({
    
    get.appId<-as.numeric(filter(steam_data, name %in% input$text)$appid)
    more.steam.data(get.appId,"supported_languages")
  })
  
  output$genres = renderText({
    
    get.appId<-as.numeric(filter(steam_data, name %in% input$text)$appid)
    the.type<-more.steam.data(get.appId,"genres")
    as.list(select(the.type, description))$description
  })
  
}

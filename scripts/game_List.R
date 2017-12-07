install.packages("rjson")
#library(jsonlite)
library(rjson)
library(dplyr)
library(tidyr)
library(plotly)





RemoveList <- function(data) {
  for (i in (1:ncol(data))){
    if(length(data[, i]) == length(unlist(data[, i]))){
      data[, i] <- unlist(data[, i])
    }
  }
  return (data)
}

steam_data<-fromJSON("data/game_data.json")
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
steam_data<-arrange(steam_data,name)%>%
  arrange(desc(userscore))%>%
  arrange(price)
#steam_data<-steam_data[-c(1),]
#steam_data$price<-steam_data$price[-c(6513:6528),]
steam_data<-steam_data[-c(15777:15814),]
steam_data$price<-steam_data$price/100

#steam_data_price<-data.frame(steam_data$price,stringsAsFactors = FALSE)
#steam_data_price[c("15283","15284"),]<-"20.00"
#steam_data_price[c("15713"),]<-"49.00"
#steam_data_price[steam_data_price=="2"]<-"2.00"
#steam_data_price[c("9140"),]<-"4.00"
#steam_data_price[c("9190"),]<-"4.20"
#steam_data_price[c("10826"),]<-"5.00"
#steam_data_price[c("10856"),]<-"5.10"



q <- steam_data %>%
  plot_ly(
    x = ~price, 
    y = ~userscore, 
    size = ~userscore, 
    color = ~userscore, 
    frame = steam_data$price, 
    text = ~name, 
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
  )
 return(q) 























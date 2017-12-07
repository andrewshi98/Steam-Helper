
#   This File Updates data fetched from steamspy.com.
#   Datas are renewed periodically considering user loading 
# time optimization.
#   You're not expected to use this library in your work.

# LastUpdate Usage Example:
# open_file <- file("LastUpdate.sdat", "r")
# as.Date(readLines(open_file))
# close(open_file)
# Second line will give you a var with date of last update.

# Install Required Packages

# install.packages("RCurl")
# install.packages("XML")

##Loading Required Library
library(XML)
library(httr)
library(jsonlite)
##

OddIndex <- function(x) x%%2 != 0 

EvenIndex <- function(x) x%%2 == 0 


RenewAllData <- function(){
  r <- GET("http://steamspy.com/api.php?request=all")
  local_file <- file("data/game_data.json", 'w')
  if(status_code(r) == 200){
    update_file <- file("data/LastUpdateAll.sdat", 'w')
    cat(as.character(Sys.time()), file = update_file)
    close(update_file)
    
    cat(content(r, "text"), file = local_file)
    close(local_file)
    return (TRUE)
  }else{return (FALSE)}
}

Renew2WeekData <- function(){
  dataurl <- "http://steamspy.com/api.php?request=top100in2weeks"
  r <- GET(dataurl)
  local_file <- file("data/game_data_2week.json", 'w')
  if(status_code(r) == 200){
    update_file <- file("data/LastUpdate2Week.sdat", 'w')
    cat(as.character(Sys.time()), file = update_file)
    close(update_file)
    
    cat(content(r, "text"), file = local_file)
    close(local_file)
    return (TRUE)
  }else{return (FALSE)}
}

RenewRealtimeUser <- function(){
  html <- GET("http://store.steampowered.com/stats/")
  if(status_code(html) != 200)
  {return (FALSE)}
  html <- htmlParse(content(html, "text"), asText = TRUE)
  player.data <- xpathSApply(html, "//tr[@class='player_count_row']//span", xmlValue)
  game.names <- xpathSApply(html, "//tr[@class='player_count_row']//a", xmlValue)
  game.links <- xpathSApply(html, "//tr[@class='player_count_row']//a/@href")
  game.links <- as.character(game.links)
  current.players <- player.data[OddIndex(1:length(player.data))]
  current.players <- as.numeric(gsub(",", "", current.players))
  
  peak.players <- player.data[EvenIndex(1:length(player.data))]
  peak.players <- as.numeric(gsub(",", "", peak.players))
  
  realtime.data <- data.frame(Name = game.names, "Current Player" = current.players, "Peak Player" = peak.players,
             Link = game.links, stringsAsFactors = FALSE)
  
  write.csv(realtime.data, "data/RealtimeUser.csv", row.names = FALSE)
  
  update_file <- file("data/LastUpdateRealtime.sdat", 'w')
  cat(as.character(Sys.time()), file = update_file)
  close(update_file)
  
  return (TRUE)
}

BiggerThan <- function(data, number){
  if(length(data) == 0){
    return (FALSE)
  }
  for(i in (1:length(data))){
    if(data[i] > number){
      return (i)
    }
  }
  return (FALSE)
}

RenewRealtimePlot <- function(){
  r <- GET("http://store.steampowered.com/stats/userdata.json")
  if(status_code(r) != 200){
    return (FALSE)
  }
  r <- data.frame(fromJSON(content(r, "text"))$data, stringsAsFactors = FALSE)
  previous_plot <- read.csv("data/RealtimePlot.csv")
  newest_time <- previous_plot$X1[nrow(previous_plot)]
  
  update_line <- BiggerThan(r$X1, newest_time)
  if(update_line == FALSE){
    return (TRUE)
  }
  r <- rbind(previous_plot, r[c(update_line:nrow(r)),])
  write.csv(r, "data/RealtimePlot.csv", row.names = FALSE)
  
  update_file <- file("data/LastUpdatePlot.sdat", 'w')
  cat(as.character(Sys.time()), file = update_file)
  close(update_file)
  
  return (TRUE)
}

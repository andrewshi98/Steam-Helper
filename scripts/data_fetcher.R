
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
##

OddIndex <- function(x) x%%2 != 0 

EvenIndex <- function(x) x%%2 == 0 


RenewAllData <- function(){
  r <- GET("http://steamspy.com/api.php?request=all")
  local_file <- file("data/game_data.json", 'w')
  if(status_code(r) == 200){
    update_file <- file("data/LastUpdateAll.sdat", 'w')
    cat(as.character(Sys.Date()), file = update_file)
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
    cat(as.character(Sys.Date()), file = update_file)
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
  return (TRUE)
}

#as.POSIXct(1512239788000/1000, origin="1970-01-01")

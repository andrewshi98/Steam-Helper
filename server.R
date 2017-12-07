# Source your files in this section

##Andrew

##

##Ryan
source("scripts/random_game_server.R")
##

#

shinyServer(function(input, output){
  MainPage_Server(input, output)
  RandomGamePage_Server(input, output)
})
# Source your files in this section

##Andrew
source("scripts/main_page_server.R")
source("scripts/online_plot_server.R")
source("scripts/detail_page_server.R")
##

##Ryan
source("scripts/random_game_server.R")
##

#

shinyServer(function(input, output){
  MainPage_Server(input, output)
  RandomGamePage_Server(input, output)
  OnlinePlot_Server(input, output)
  DetailPageServer(input, output)
  RandomGamePage_Server(input, output)
})
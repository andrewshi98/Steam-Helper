# Source your files in this section

##Andrew
source("scripts/main_page_server.R")
source("scripts/online_plot_server.R")
source("scripts/detail_page_server.R")
source("scripts/custom_graph_server.R")
##

##Ryan
source("scripts/random_game_server.R")
##

##Sailesh
source("scripts/charts_server.R")
source("scripts/project_description_server.R")
#

##Martin
source("scripts/Searching_Function_server.R")
#

shinyServer(function(input, output){
  MainPage_Server(input, output)
  RandomGamePage_Server(input, output)
  CustomGraph_Server(input, output)
  OnlinePlot_Server(input, output)
  DetailPageServer(input, output)
  RandomGamePage_Server(input, output)
  Charts_Server(input,output)
  Searching_Function_Server(input,output)
  project_description_server(input,output)
})
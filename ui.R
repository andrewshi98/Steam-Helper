library(shiny)
library(plotly)
library(shinythemes)

source("scripts/main_page_ui.R")
source("scripts/custom_graph_ui.R")
source("scripts/online_plot_ui.R")
source("scripts/detail_page_ui.R")
source("scripts/random_game_ui.R")
source("scripts/charts_ui.R")
source("scripts/Searching_Function_ui.R")
source("scripts/project_description_ui.R")

#   In order to make this project more organized, we
# only reference functions written in scripts/ that
# has ui as well as server information stored.
# Please go to scripts/main_page_ui.R for more
# information about this practice.
#   Also, plase follow the naming practice for your
# scripts:
#   {file name}_ui/server.R

shinyUI(
    navbarPage("Steam Helper",
               MainPageUI(),  # The only thing it does is calling the functino.
                              # function return something like return(tabPanel("title")) 
               OnlinePlotUI(),
               CustomGraphUI(),
               DetailPageUI(),
               RandomGameUI(),
               Charts_UI(),
               Searching_Function_UI(),
               project_description_UI()
    )
)
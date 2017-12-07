library(shiny)
library(plotly)

source("scripts/main_page_ui.R")

#   In order to make this project more organized, we
# only reference functions written in scripts/ that
# has ui as well as server information stored.
# Please go to scripts/main_page_ui.R for more
# information about this practice.
#   Also, plase follow the naming practice for your
# scripts:
#   {file name}_ui/server.R

Charts_UI<-function(){
    return(
               
               tabPanel(
                 "Game User Data Visuals",
                        
                        # Side panel for controls
                 
                        
                        # Input to select variable to map
                        
                        
                        # Main panel: display plotly map
                        mainPanel(
                          plotlyOutput('scatter'),
                          HTML(
                            paste(
                              '<br/>'
                            )
                          ),
                          plotlyOutput('scatter3d')
                        )
                        
               )
    )}

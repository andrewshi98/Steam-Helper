library(plotly)
library(dplyr)

source("scripts/data_renewer.R")

GenerateUserPlot <- function(){
  graph <- read.csv("data/RealtimePlot.csv", stringsAsFactors = FALSE)
  graph$X1 <- as.POSIXct(graph$X1/1000, origin="1970-01-01")
  
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
  
  p <- plot_ly(graph, x = ~X1, y = ~X2, type = "scatter", mode = "lines", color = "rgb(200, 200, 200)") %>% 
    layout(paper_bgcolor='rgba(50, 50, 50, 80)', plot_bgcolor='rgba(100, 100, 100, 50)',
           xaxis = xstyle, yaxis = ystyle)
}

OnlinePlot_Server <- function(input, output){
  RenewCheck_Plot()
  output$onlineplot <- renderPlotly({GenerateUserPlot()})
}
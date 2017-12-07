library(shiny)
library(plotly)

#Generates graph from dataset based on user choice

GenerateCustomGraph <- function(input, output){
  labelfont <- list(
    color = "rgb(255, 255, 255)"
  )
  
  xstyle = list(title = input$selectX,
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
  ystyle = list(title = input$selectY,
                gridcolor = 'rgb(150, 150, 150)',
                showgrid = TRUE,
                showline = FALSE,
                showticklabels = TRUE,
                tickcolor = 'rgb(127,127,127)',
                ticks = 'outside',
                zeroline = FALSE,
                titlefont = labelfont,
                tickfont = list(color = "rgb(255, 255, 255)"))
  
  X.choice <- gsub(" ", "_", tolower(input$selectX))
  Y.choice <- gsub(" ", "_", tolower(input$selectY))
  p <- plot_ly(game.data.raw, x = game.data.raw[[X.choice]], y = game.data.raw[[Y.choice]],
                  type = "scatter", hoverinfo = "text",
                  text = sprintf("%s:\n%s:%s\n%s:%s", game.data.raw$name,
                                 input$selectX, game.data.raw[[X.choice]],
                                 input$selectY, game.data.raw[[Y.choice]]),
               color = "rgb(200, 200, 200)") %>% 
            layout(title = sprintf("%s vs. %s", input$selectX, input$selectY),
                   paper_bgcolor='rgba(50, 50, 50, 80)', plot_bgcolor='rgba(100, 100, 100, 50)',
                   xaxis = xstyle, yaxis = ystyle, font = list(color = "white"))
  return (p)
}

CustomGraph_Server <- function(input, output){
  output$customgraph <- renderPlotly({GenerateCustomGraph(input, output)})
}
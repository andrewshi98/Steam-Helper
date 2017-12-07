library(plotly)
library(dplyr)
library(jsonlite)

DetailPageServer <- function(input, output){
  html.file <- file("www/game_detail.html")
  html <- readLines(html.file)
  close(html.file)
  output$text <- renderUI({
    api.url <- sprintf("http://store.steampowered.com/api/appdetails?appids=%s", input$select)
    r <- GET(api.url)
    r <- fromJSON(content(r, "text"))[[1]]$data
    background.url <- r$header_image
    game.name <- as.character(detail_page_game.data$name[detail_page_game.data$appid==input$select])
    html <- sub("%url", background.url, html)
    html <- sub("%name", game.name, html)
    HTML(html)
    })
}
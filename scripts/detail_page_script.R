library(jsonlite)

GetGameOptionList <- function(){
  game.data.file <- file("data/game_data.json", "r")
  game.data <- fromJSON(readLines(game.data.file))
  close(game.data.file)
  game.data <- data.frame(do.call(rbind, game.data), stringsAsFactors = FALSE)
  
  option.list <- as.vector(unlist(game.data$appid))
  names(option.list) <- as.vector(unlist(game.data$name))
  
  detail_page_game.data <<-  game.data
  
  return (option.list)
}

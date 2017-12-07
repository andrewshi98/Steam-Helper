library(shiny)

RemoveList <- function(data) {
  for (i in (1:ncol(data))){
    if(length(data[, i]) == length(unlist(data[, i]))){
      data[, i] <- unlist(data[, i])
    }
  }
  return (data)
}

#Function that extract data

data_frame_extraction<-function(){
  steam_data<-jsonlite::fromJSON("data/game_data.json")
  max.length <- max(sapply(steam_data, length))
  steam_data <- lapply(steam_data, function(v) { c(v, rep(NA, max.length-length(v)))})
  steam_data<- do.call(rbind, steam_data)
  steam_data<- data.frame(steam_data, stringsAsFactors = FALSE)
  rownames(steam_data)<-NULL
  steam_data <- RemoveList(steam_data)
  steam_data$price[steam_data$price=="NULL"]<-"1"
  steam_data$price[steam_data$price=="0"]<-"1"
  steam_data$price<-unlist(steam_data$price)
  steam_data$price<-as.numeric(steam_data$price)/100
  return(steam_data)
}


#Returns list of name in data set
GetDataRowOption <- function(){
  option.list <- colnames(game.data.raw)
  option.list <- option.list[(5:length(option.list))]
  option.list.name <- gsub("_", " ", option.list)
  option.list.name <- gsub("(?<=\\b)([a-z])", "\\U\\1", option.list.name, perl=TRUE)
  names(option.list.name) <- option.list.name
  return (option.list.name)
}

#Output the custom graph
CustomGraphUI <- function(){
  game.data.raw <<- data_frame_extraction()
  return (tabPanel("Custom Graph",
                   #You do exactly the same thing as you would in the ui.R file
                     sidebarPanel({selectInput("selectX", label = "Choose X Axis",
                                                choices = GetDataRowOption(),
                                                selected = "Score Rank")},
                                  {selectInput("selectY", label = "Choose Y Axis",
                                               choices = GetDataRowOption(),
                                               selected = "Positive")}),
                     mainPanel(plotlyOutput("customgraph"))
  )
  )
}

source("scripts/data_fetcher.R")

RenewCheck_MainPage <- function(){
  counter <- 0
  open_file <- file("data/LastUpdateRealtime.sdat", "r")
  lastupdate.last <- as.POSIXct(readLines(open_file, warn = FALSE))
  if(difftime(Sys.time(), lastupdate.last, units = "mins")>20){
    RenewRealtimeUser()
    counter <- counter + 1
  }
  close(open_file)
  
  open_file <- file("data/LastUpdate2Week.sdat", "r")
  lastupdate2week.last <- as.POSIXct(readLines(open_file, warn = FALSE))
  if(difftime(Sys.time(), lastupdate2week.last, units = "days") > 7){
    RenewRealtimeUser()
    counter <- counter + 1
  }
  close(open_file)
  
  open_file <- file("data/LastUpdateAll.sdat", "r")
  lastupdateall.last <- as.POSIXct(readLines(open_file, warn = FALSE))
  if(difftime(Sys.time(), lastupdateall.last, units = "days") > 7){
    RenewRealtimeUser()
    counter <- counter + 1
  }
  close(open_file)
  
  return (counter)
}

RenewCheck_Plot <- function(input, output){
  
  open_file <- file("data/LastUpdatePlot.sdat", "r")
  lastupdate.last <- as.POSIXct(readLines(open_file, warn = FALSE))
  if(difftime(Sys.time(), lastupdate.last, units = "mins")>60){
    RenewRealtimePlot()
  }
  close(open_file)
  
  return (TRUE)
}

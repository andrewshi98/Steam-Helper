
#   This File Updates data fetched from steamspy.com.
#   Datas are renewed periodically considering user loading 
# time optimization.
#   You're not expected to use this library in your work.

# LastUpdate Usage Example:
# open_file <- file("LastUpdate.sdat", "r")
# as.Date(readLines(open_file))
# close(open_file)
# Second line will give you a var with date of last update.

##Loading Required Library
library(httr)
##

RenewData <- function(){
  r <- GET("http://steamspy.com/api.php?request=all")
  local_file <- file("game_data.json")
  if(status_code(r) == 200){
    update_file <- file("LastUpdate.sdat", 'w')
    cat(as.character(Sys.Date()), file = update_file)
    close(update_file)
    
    writeLines(content(r, "text"), local_file)
    close(local_file)
    return (TRUE)
  }else{return (FALSE)}
}

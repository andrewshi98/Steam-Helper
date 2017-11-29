library(httr)
r <- GET("http://steamspy.com/api.php?request=all")
local_file <- file("game_data.json")
if(status_code(r) == 200){
  writeLines(content(r, "text"), local_file)
  close(local_file)
}
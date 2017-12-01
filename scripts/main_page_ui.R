library(shiny)

# This is a example of what your ui scripts should look like.
# Please follow syntax so it makes our collaboration easier.

MainPageUI <- function(){
  return (tabPanel("Main Page",
                   #You do exactly the same thing as you would in the ui.R file
                   checkboxInput("demo_element", "demo_element")))
}

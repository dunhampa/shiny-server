library(shiny)
library(plotly)
shinyUI(fluidPage(
  titlePanel("Visualize Many Models"),
  sidebarLayout(
    sidebarPanel(
      h3("Select Data Set"),
      
      
       

      
      uiOutput("node"),
      h3("Slope"),
      uiOutput("indepVar"),
      #textOutput("slopeOut"),
      h3("Intercept"),
      textOutput("text1")
      
      
    ),
    mainPanel(
      #plotOutput("plot1", brush = brushOpts(
    #    id = "brush1"
     # )
      plotlyOutput('plot1')
      
    
      
    )
  )
))
library(shiny)
library(plotly)
library(markdown)

shinyUI(fluidPage(
  
  titlePanel("Easy Explore Plots"),
 
  sidebarLayout(
    sidebarPanel(
      h5("1) Select Data Set"),
      uiOutput("node"),
      h5(" 2) Select Dependent Variable"),
      uiOutput("indepVar")

    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Plot", plotlyOutput("plot1")), 
        tabPanel("Documentation", includeMarkdown("documentation.md"))
        )
      )
  )
))
#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Copy the line below to make a text input box
  textInput("text", label = h3("Enter Text Here:"), value = ""),
  
  hr(),
  h4("Predicted Next Word:"),
  textOutput("selected_var"),
  fluidRow(column(3, verbatimTextOutput("value")))
  
)

load("CompactPredictTB.Rda")
load("predict_for_null.Rda")

predict.tb<-Compact.Predict.TB
#predict.tb<-ThirtyB

#inputToPass<-input$text
Predict_Return<-function(input){
  
  library(tidytext)
  library(dplyr)
  
 
  #Get string into text
  input<-(data.frame(input_text=input, stringsAsFactors = FALSE))
  
  #return rows of words
  words<-input %>%
    tidytext::unnest_tokens(word, input_text)
  
  #get backoff inputs
  backoff_3<<-apply(tail(words, n=3),2,paste,collapse=" ")
  backoff_2<<-apply(tail(words, n=2),2,paste,collapse=" ")
  backoff_1<<-tail(words, n=1)[1,1]
  
  #Markov/Backoff Model
  
  
  #Predicting on 3 words
  predict_return<-predict.tb[predict.tb$Ngram_Input==backoff_3,]
  
  #Backing off to 2 words
  if(nrow(predict_return)<1){
    
    #2 work back off
    predict_return<-predict.tb[predict.tb$Ngram_Input==backoff_2,]
    
    #Backing off to 1 word
    if(nrow(predict_return)<1){
      predict_return<-predict.tb[predict.tb$Ngram_Input==backoff_1,]
      
      if(nrow(predict_return)<1){
        #Backing off to common words
        predict_for_null$Ngram_Input<-backoff_1
        predict_return<-predict_for_null
      }
      
    }
    
  }
  #print(predict_return)
  predict_return
  
}

Predict_Word<-function(predict_return){
  
  
  if(is.na(predict_return$Ngram_Input[1])){
    return("")
  }
  return<-predict_return[predict_return$max=="TRUE",]
  row<-sample_n(return, size=1)
  out<-row$next_word_predict
  out
  
}







# Define server logic required to draw a histogram
server <- function(input, output) {
  #print("hello")
  
  #output$selected_var <- renderPrint({ input$text })
  
  #Predict<-reactive({
    #inputToPass<-input$text
    #print("hello")})
  
  currentPrediction <- reactive({ Predict_Word(Predict_Return(input$text)) })
  
  #WORKED: output$selected_var<- renderText({ Predict_Word(Predict_Return(input$text)) })
  
  
  
  
  
  output$selected_var <- renderText({ currentPrediction() })
  
  
  

}

  
  
  
  
  
  


# Run the application 
shinyApp(ui = ui, server = server)


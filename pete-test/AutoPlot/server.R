library(shiny)
options(shiny.sanitize.errors = FALSE)


shinyServer(function(input, output) {

  
  output$slopeOut <- renderText({
    if(is.null(model())){
      "No Model Found"
    } else {
      model()[[1]][2]
    }
  })
  
  output$intOut <- renderText({
    if(is.null(model())){
      "No Model Found"
    } else {
      model()[[1]][1]
    }
  })
  
  #Get Node Selection
  output$plot1 <- renderPlotly({
    if(is.null(input$node)){
      
    }
    else{
      PlotlyPlot(c(input$indepVar),input$node)
    }
      
    
  })
  
  #Outputing Node Selection
  output$node <- renderUI({
    selectInput("node", "Node:", returnList() ) 
  })
  
 

  
  getMyData<-function(fileName)
  {
    #myfile <- file.path("serverdata", fileName) 
    
    datain<-read.csv2(paste0('./serverdata/',fileName))
    datain[,3]<-as.Date(datain[,3],"%Y-%m-%d")
    #datain[, 1:2] <- sapply(data[, 1:2], as.numeric)
    #datain<-readRDS(myfile)
   
  
    #datain<-readRDS(paste0(getwd(),"\\serverdata\\",fileName))
    mydata<-datain[,seq(3,length(colnames(datain)),by=1)]
    mydata
  }
  
  #mydata<-getMyData(input$node)
  
  
  #Builds the plotly plot
  PlotlyPlot<-function(colindex, fileName)
  {
    
    library(plotly)
    
    
    #myfile <- file.path("serverdata", fileName) 
    #dat <- read.csv(myfile, header=T)
    datain<-read.csv2(paste0('./serverdata/',fileName))
    #datain<-read.csv2(myfile)
    #datain<-readRDS(myfile)
    datain[,3]<-as.Date(datain[,3],"%Y-%m-%d")
    #datain[, 1:2] <- sapply(data[, 1:2], as.numeric)
    
    #datain<-readRDS(paste0(getwd(),"\\serverdata\\",fileName))
    
    
   #if independent variable is a factor, let's do a box plot
    if(is.factor(datain[,colindex]))
    {
      topfactors <- rev(sort(table(datain[,colindex]))[1:8])# frequency of values in f$c
      topfactors<-as.data.frame(topfactors)
      topfactors<-topfactors[topfactors$Freq>10,]
      globaltop<<-topfactors
      #datain<-datain[datain[,colindex] %in% topfactors$Var1,]
      
      
      p <- plot_ly(datain, y = ~Mean.LMP.Price.USD, color = ~datain[,colindex], type = "box")
    }
    
    #if independent variable is not a factor, let's risk it with a scatterplot
    else
    {
      
      #three numbers for random number
      colors<-as.integer(runif(6, 0, 255))
      #for coloring the plot:
      colorstring=paste0('rgba','(',colors[1],',', colors[2],',' ,colors[3],',', '.9 )')
      colorstring2=paste0('rgba','(',colors[4],',', colors[5],',' ,colors[6],',', '.9 )')
      print(colorstring)
      p <- plot_ly(data = datain, x = ~datain[,colindex], y = ~Mean.LMP.Price.USD, type="scatter",mode="markers",
                   marker = list(size = 10,
                                 color = colorstring,
                                # color = 'rgba(255, 182, 193, .9)',
                                 #line = list(color = 'rgba(152, 0, 0, .8)',
                                line = list(color = colorstring2,
                                             width = 2))) %>%
        layout(title = 'Styled Scatter',
               yaxis = list(zeroline = FALSE),
               xaxis = list(zeroline = FALSE, title=colindex))
    }
    p
    
  }
  
  #Dynamically loading colNames as independent variables
  output$indepVar <- renderUI({
    if(is.null(getMyData(input$node))){
      print("here")
    } 
    else {
      #print(list(colnames(getMyData(input$node))))
      selectInput("indepVar", "Independent Variable",colnames(getMyData(input$node)))
    }
  })
  
  
  
  
  
  
})

#Returning list based on file names 
returnList<-function(){
  
  node.files<-list.files("./serverdata/")
}





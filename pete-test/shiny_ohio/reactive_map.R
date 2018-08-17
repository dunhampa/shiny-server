

#https://rstudio.github.io/leaflet/shapes.html

library(rgdal)
library(magrittr)
library(leaflet)
library(jsonlite)

# From https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html
states <- readOGR("county/cb_2015_us_county_20m.shp",
                  layer = "cb_2015_us_county_20m", GDAL1_integer64_policy = TRUE)

Statekey<-read.csv('STATEFPtoSTATENAME_Key.csv', colClasses=c('character'))
states<-merge(x=states, y=Statekey, by="STATEFP", all=TRUE)

neStates <- subset(states, states$STATENAME %in% c(
  "Ohio"
))

states<-merge(x=states, y=Statekey, by="STATEFP", all=TRUE)
leaflet(neStates) %>%
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              fillColor = ~colorQuantile("Reds", AWATER)(AWATER),
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE),
              popup=~NAME)



example<-function(map){
  
  output$myMap <- renderLeaflet({
    map
  })
  
  
  output$MyGraph <- renderPlot({  
    event <- input$myMap_shape_click #Critical Line!!!
    
    
    
    GraphData <- GraphData[event$id] # subsetting example
    print(GrapData)
    
  }) 
  
  
}


example(neStates)

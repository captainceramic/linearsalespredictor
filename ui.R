library(shiny)

num.sales <- seq(0, 50, by = 1)

shinyUI(fluidPage(

  # Application title
  titlePanel("Linear Sales Predictor"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(

      selectInput("sales2011", "2011",
                  num.sales),
      selectInput("sales2012", "2012",
                  num.sales),
      selectInput("sales2013", "2013",
                  num.sales),
      selectInput("sales2014", "2014",
                  num.sales),
      selectInput("sales2015", "2015",
                  num.sales),
      
      selectInput("predictYear", "Year to predict:",
                  seq(2016, 2030, by = 1))
                  
    ),

    # Show a plot of the generated distribution
    mainPanel(
      h3("Welcome to the Linear Sales Predictor!"),
      p(paste(c("To use the predictor, first enter the number of sales for previous",
              "years in the boxes to the left. Then select the future year you want to",
              "predict sales for. Let the magic of linear models grow your business!"))),
      plotOutput("distPlot"),
      textOutput("predictVal")
    )
  )
))

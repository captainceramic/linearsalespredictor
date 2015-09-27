library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  
  # Non-reactive.
  year.vals <- seq(2011, 2015, by = 1)
  
  # Reactive Stuff.
  num.sales <- reactive(as.numeric(c(input$sales2011, input$sales2012,
                                     input$sales2013, input$sales2014,
                                     input$sales2015)))
  
  futureYear <- reactive(as.numeric(input$predictYear))
  
  # Set up the base sales data.
  sales.data <- reactive({
    
    sales <- num.sales()
    df <- data.frame(year.vals, num.sales = sales,
                     sources = "Historical Data")
    df
  })
  
  lin.model <- reactive({
    in.data <- sales.data()
    model <- lm(num.sales ~ year.vals, data = in.data)
  })

  # Create a linear model  
  outdf <- reactive({
    
    in.data <- sales.data()
    futYear <- futureYear()
    model <- lin.model()
  
    # Predict a new value.  
    new_val <- predict(model, data.frame(year.vals = futYear))

    df <- rbind(in.data, data.frame(year.vals = futYear,
                                    num.sales = new_val,
                                    sources = "Model Prediction"))
    
    df
    
  })
    
  output$distPlot <- renderPlot({
    
    df.sales <- outdf()
    model <- lin.model()
    
    lm.params <- coef(model)
    
    df.sales$num.sales[df.sales$num.sales < 0.0] <- 0.0
    
    g <- ggplot(df.sales)
    g <- g + geom_point(aes(x = year.vals, y = num.sales),
                        size = 8.0, color = "#AA5439")
    g <- g + geom_point(aes(x = year.vals, y = num.sales, color = sources),
                        size = 6.0) 
    g <- g + scale_x_continuous(breaks = seq(2011, 2045, by = 1),
                                name = "Year")
    g <- g + scale_y_continuous(name = "Sales")
    g <- g + scale_color_manual(values = c("#437313", "#4D0F53"),
                                name = "Data Source")
    
    g <- g + geom_abline(intercept = lm.params[1],
                         slope = lm.params[2],
                         linetype = "longdash")
    g <- g + theme(panel.background = element_rect(fill = "#FFECE6"))

    print(g)
    
  })
  
  output$predictVal <- renderText({
    
    futYear <- futureYear()
    predDF <- outdf()
    
    predValue <- round(predDF[predDF$year.vals == futYear, ]$num.sales, 2)
    
    if(predValue < 0 ) predValue <- 0.0
    
    paste("The linear model predicts", predValue,
          "units will be sold in the year", futYear)
    
  })

})

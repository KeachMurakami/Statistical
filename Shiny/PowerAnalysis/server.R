require(ggplot2)
require(shiny)
library(shinydashboard)

shinyServer(function(input, output) {
  v <- reactiveValues(data = NULL)

  observeEvent(input$pre, {
    v$data <- 0
  })
  observeEvent(input$post, {
    v$data <- 1
  })
  observeEvent(input$reset, {
    v$data <- NULL
  })
  output$URLlink <- renderText({'<a href = "https://github.com/KeachMurakami/Statistical/tree/master/Shiny/PowerAnalysis">コードなど@GitHub</a>'})
  output$fig <- renderPlot({
    num <-
      ceiling(
        power.t.test(delta = as.numeric(input$dif),
                     sd = as.numeric(input$SD),
                     sig.level = as.numeric(input$criteria)/100,
                     power = as.numeric(input$power)/100)$n
        )

    dif <-
      power.t.test(n = as.numeric(input$num),
                   sd = as.numeric(input$SD),
                   sig.level = as.numeric(input$criteria)/100,
                   power = as.numeric(input$power)/100)$delta
      
    
    if(is.null(v$data)) return()
    else if(v$data == 0){ 
      data <-  data.frame(Trtm = c("Ctrl", "Trtm"), value = c(100, 100 + input$dif), se = input$SD/sqrt(num - 1))
      return(
        ggplot(data = data, aes(x = Trtm, y = value, fill = Trtm)) +
        theme_grey(base_size = 20) +
        guides(fill = FALSE) + 
        geom_bar(stat = "identity") +
        geom_errorbar(aes(ymin = value - se, ymax = value + se), width = 0.3) +
        coord_cartesian(ylim = c(0, ceiling(input$dif/10) * 10 + 120)) +
        xlab(paste0(num, " samples are required per treatment")) + ylab("")
      )
    }
    else if(v$data == 1){
      data <- data.frame(Trtm = c("Ctrl", "Trtm"), value = c(100, 100 + dif), se = input$SD/sqrt(input$num - 1))
      return(
        ggplot(data = data, aes(x = Trtm, y = value, fill = Trtm)) +
        theme_grey(base_size = 20) +
        guides(fill = FALSE) + 
        geom_bar(stat = "identity") +
        geom_errorbar(aes(ymin = value - se, ymax = value + se), width = 0.3) +
        coord_cartesian(ylim = c(0, 100 + dif + ceiling(input$SD/sqrt(input$num - 1) / 10 + 1) * 10)) +
        xlab(paste0("You can detect ", round(dif, 0), "% effect with a ", input$power, "% possibility")) + ylab("")
      )
    }
  })  
#   output$p1 <- renderPlot({
#     num <-
#       power.t.test(delta = as.numeric(input$dif), sd = as.numeric(input$SD),
#                  sig.level = as.numeric(input$criteria)/100, power = as.numeric(input$power)/100) %>%
#       .$n %>% ceiling
#     
#     if(is.null(v$data)) return()
#     data.frame(Trtm = c("Ctrl", "Trtm"), value = c(100, 100 + input$dif), se = input$SD/sqrt(num - 1)) %>%
#       ggplot(aes(x = Trtm, y = value, fill = Trtm)) +
#       guides(fill = FALSE) + 
#       geom_bar(stat = "identity") +
#       geom_errorbar(aes(ymin = value - se, ymax = value + se), width = 0.3) +
#       annotate(geom = "text", x = 1.5, y = 20, label = paste0(num, " samples are required per treatment")) +
#       xlab("") + ylab("") %>%
#       return
#   })
#   
#   output$p2 <- renderPlot({
#     dif <-
#       power.t.test(n = as.numeric(input$num), sd = as.numeric(input$SD),
#                    sig.level = as.numeric(input$criteria)/100, power = as.numeric(input$power)/100) %>%
#       .$delta
#     
#     if(is.null(v$data)) return()    
#     data.frame(Trtm = c("Ctrl", "Trtm"), value = c(100, 100 + input$dif), se = input$SD/sqrt(input$num - 1)) %>%
#       ggplot(aes(x = Trtm, y = value, fill = Trtm)) +
#       guides(fill = FALSE) + 
#       geom_bar(stat = "identity") +
#       geom_errorbar(aes(ymin = value - se, ymax = value + se), width = 0.3) +
#       annotate(geom = "text", x = 1.5, y = 20, label = paste0("You can detect ", round(dif, 0), "% effect at ", input$power, "% possibilities")) +
#       xlab("") + ylab("") %>%
#       return
#   })  
})
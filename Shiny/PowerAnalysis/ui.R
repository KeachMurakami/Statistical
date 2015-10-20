require(ggplot2)
require(shiny)
library(shinydashboard)

shinyUI(
  dashboardPage(
    dashboardHeader(title = "検定力分析アプリ"),
    dashboardSidebar(
      actionButton("pre", "事前分析"),
      actionButton("post", "事後分析"),
      actionButton("reset", "Clear"), 
      sliderInput("num", label = "サンプルサイズ", min = 1, max = 20, value = 4, step = 1),
      sliderInput("dif", label = "平均値の差", min = 0, max = 100, value = 20, step = 5),
      sliderInput("SD", label = "標本標準偏差 (変動係数)", min = 5, max = 100, value = 20, step = 5),
      sliderInput("power", label = "検定力(%)", min = 50, max = 90, value = 80, step = 5),
      sliderInput("criteria", label = "危険率α", min = 1, max = 10, value = 5, step = 1)
    ),
    dashboardBody(          
      plotOutput("fig", width = "500px", height = "500px")
    )
#     navlistPanel(
#       navbarMenu(
#         "どっち？",
#         tabPanel("事前分析 (サンプルサイズを決める)", plotOutput("p1")),
#         tabPanel("事後分析 (効果量を決める)", plotOutput("p2")))
#      ),
    )
#  theme = "http://bootswatch.com/cerulean/bootstrap.min.css"
)
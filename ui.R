## Developing Data Products
## Course Project
## By S.S.

library(shiny)
# Load UI and CSS located in 'www' subfolder
shinyUI(fluidPage(theme="bootstrap.css",
                  h1("Egghead!", style="color:#ffa500"),
                  sidebarLayout(    
                      sidebarPanel(
                          h4(textOutput("i"), style="color:#ffa500"),
                          uiOutput("radio"),
                          actionButton("goButton", "Buzzer!"),
                          br(""),
                          br(""),
                          br(""),
                          br(""),
                          h3(textOutput("status"), align="center")
                      ),
                      # Tabbed panels to show more information
                      mainPanel(
                          tabsetPanel(
                              tabPanel(h4("Main"),
                                       h2('Your Total Earnings', style="color:#ffa500"),
                                       h3(textOutput("earning")),
                                       h2('Category', style="color:#ffa500"),
                                       h3(textOutput("category")),
                                       h2('Value', style="color:#ffa500"),
                                       h3(textOutput("value")),
                                       h2('Previous Correct Answer', style="color:#ffa500"),
                                       h3(textOutput("prevAnswer"))
                              ),
                              tabPanel(h4("Real-time Charts"),
                                       h3(textOutput("noCharts")),
                                       plotOutput("plotPie"),
                                       plotOutput("plotBar")
                              ),
                              tabPanel(h4("Help"),
                                       h4("Welcome to Egghead! v1.0 by S.S."),
                                       br(""),
                                       p('This application makes use of over 200,000 real Jeopardy! questions
  that were aired on TV from 1984 to 2012.'),
                                       p('The directions to use this brain exercise are simple. For each question, select a multiple
  choice answer and click Buzzer! Your current total earnings will be calculated and updated
 instantly as well as question information based on your answers. If you answer correctly, the $ value of the current question
will be added to your total earnings or it will be subtracted if you answer incorrectly. A notification will be shown if you are correct or not
along with the correct answer. A new question will be asked after every button click.'),
                                       p('You can also see the Real-time Charts tab to see instantly updated
  charts of how well you are currently performing. They will only display after you
  have answered at least one question and/or a correct answer.'),
                                       p('With these real questions, you can practice and become an Egghead!'),
                                       p('The dataset used is a collection by fans from the publicly contributed content on http://www.j-archive.com.
   Jeopardy! is a registered trademark of Jeopardy Productions, Inc.')
                              )
                          )
                      )
                  )
)
)

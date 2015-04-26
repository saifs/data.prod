## Developing Data Products
## Course Project
## By S.S.

library(shiny)

# Load server
shinyServer(
    function(input, output) {
        # Load dataset and clean
        data <- read.csv("JEOPARDY.csv", colClasses="character")
        data <- data[,-c(1,2,3)]
        data <- data[!data$Value == "None",]
        data <- data[!grepl("<a",data$Question),]
        data$Value <- gsub(',', '', data$Value)
        data$Value <- gsub('\\$', '', data$Value)
        data$Value <- as.numeric(data$Value)
        # Initialize values used for calculations and display
        earning <- 0
        status <- ""
        answersCompleted <- ""
        answerDistro <- NULL
        radioAnswer <- ""
        valuesCompleted <- 0
        statusCompleted <- 0
        # Observe action button presses and then perform what's inside here
        observe({
            input$goButton
            i <- input$goButton + 1
            # Take random samples from the dataset
            random <- data[sample(nrow(data),4),]
            selected <- random[sample(nrow(random),1),]
            answersCompleted[i] <<- selected$Answer
            valuesCompleted[i] <<- selected$Value
            # Output various text to UI            
            output$i <- renderText({paste("Question",i)})
            output$earning <- renderText({paste("$",earning, sep="")})
            output$category <- renderText({selected$Category})
            output$value <- renderText({paste("$",selected$Value, sep="")})
            # Create radio buttons for user reactive input
            output$radio <- renderUI({
                radioButtons("answer", label=selected$Question,
                             choices=random$Answer)
            })
            output$prevAnswer <- renderText({answersCompleted[i-1]})
            # Only execute after action button pressed at least once
            if (input$goButton != 0) {
                output$noCharts <- renderText("")
                radioAnswer <- isolate(input$answer)
                # If user answers correctly
                if (radioAnswer==answersCompleted[i-1]){
                    # Perform calculations
                    status <- "RIGHT!"
                    statusCompleted[i-1] <<- 1
                    answerDistro[i-1] <<- valuesCompleted[i-1]
                    earning <<- earning + valuesCompleted[i-1]
                    # Bar plot
                    output$plotBar <- renderPlot({
                        par(cex=1.5, col="white")
                        barplot(table(answerDistro), 
                                xlab="Value of Question ($)",
                                ylab="Number of times",
                                main="Correct Answers Distribution",
                                col="#0ce3ac", fg="white",
                                col.main="white", col.lab="white", col.axis="white")
                    }, bg="transparent")
                }
                else {
                    # Perform calculations if wrong
                    status <- "WRONG!"
                    statusCompleted[i-1] <<- 0
                    earning <<- earning - valuesCompleted[i-1]
                }
                # Pie chart
                output$plotPie <- renderPlot({
                    slices <- c(sum(statusCompleted==0), sum(statusCompleted==1))
                    lbls <- c("Wrong", "Right")
                    pct <- round(slices/sum(slices)*100)
                    lbls <- paste(lbls, " ", pct, "%", sep="")
                    par(cex=1.5, col="white")
                    pie(slices, radius=1, init.angle=90,
                        main="Answer Ratio", labels=lbls,
                        col=c("#ffa500", "#0ce3ac"), col.main="white")
                }, bg="transparent")
                output$status <- renderText(status)
            }
            else {
                # Filler text for charts
                output$noCharts <- renderText("You need to answer at least one
                           question to view the Answer Ratio chart and at least one correct
                          answer to view the Correct Answers Distribution chart.") }
        })
    }
)

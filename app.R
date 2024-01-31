library(shiny)
library(ggplot2)
library(tidyverse)
# Load data

source('final_model.R')


df1$DEATH_EVENT<-ifelse(df1$DEATH_EVENT=="0","Survived","Died")




# Function to create custom plot
plot_custom <- function(data, x = "DEATH_EVENT", y = "age") {
  if (!(x %in% names(data) && y %in% names(data))) {
    stop("Invalid column names provided.")
  }
  if (is.numeric(data[[y]])) {
    ggplot(data, aes_string(x = x, y = y, fill = x)) +
      geom_boxplot() +
      labs(x = x, y = y) +
      theme_classic()
  } else {
    count <- as.data.frame(prop.table(table(data[[x]], data[[y]])))
    colnames(count) <- c("Dead", y, "Rate")
    ggplot(data = count, aes(x = get(y), y = Rate, fill = Dead)) +
      geom_bar(stat = 'identity', position = 'dodge') +
      labs(x = y) +
      theme_classic()
  }
}

# Function to summarise dataset
data_summary <- function(data, x = "DEATH_EVENT", y = "age") {
  if (!(x %in% names(data) && y %in% names(data))) {
    stop("Invalid column names provided.")
  }
  
  if (is.numeric(data[[y]])) {
    summary_data <- data.frame(
      Group = unique(data[[x]]),
      Min = tapply(data[[y]], data[[x]], min),
      Q1 = tapply(data[[y]], data[[x]], quantile,p=0.25),
      Median = tapply(data[[y]], data[[x]], median),
      Mean = tapply(data[[y]], data[[x]], mean),
      Q3= tapply(data[[y]], data[[x]], quantile,p=0.75),
      Max = tapply(data[[y]], data[[x]], max),
      SD = tapply(data[[y]], data[[x]], sd)
    )
    return(summary_data)
  } else {
    prop_data <- as.data.frame(prop.table(table(data[[x]], data[[y]])))
    colnames(prop_data)<-c("Class",y,"Rate")
    return(prop_data)
  }
}




# Shiny UI
ui <- fluidPage(
  titlePanel("Survival Rate Prediction of Heart Failure"),
  tabsetPanel(
    tabPanel("Data description",
             mainPanel(
               HTML("
               <p>This Shiny app explores the dataset containing health records of 299 heart failure patients at the Faisalabad
        Institute of Cardiology and at the Allied Hospital in Faisalabad (Punjab, Pakistan), during April–December 2015.</p>
        
        <p>The patients consisted of 105 women and 194 men, with ages ranging between 40 and 95 years old. All 299 patients had left
        ventricular systolic dysfunction and had previous heart failures that put them in classes III or IV of New York Heart Association (NYHA)
        classification of the stages of heart failure.</p>
        
        <p> Dataset contains 12 independent related covariates and one dependent variable. All the variables will be described below:<p>

              <ul>
                <li><strong>Age:</strong> Age of the patient (Years)</li>
                <li><strong>Anaemia:</strong> Decrease of red blood cells or hemoglobin. 0 as no anaemia; 1 otherwise</li>
                <li><strong>Creatinine Phosphokinase:</strong> Level of the CPK enzyme in the blood (mcg/L)</li>
                <li><strong>Diabetes:</strong> If the patient has diabetes. 0 if the patient has no diabetes; 1 otherwise</li>
                <li><strong>Ejection Fraction:</strong> Percentage of blood leaving the heart at each contraction (Percentage)</li>
                <li><strong>High Blood Pressure:</strong> If the patient has hypertension. 0 as no high blood pressure; 1 otherwise</li>
                <li><strong>Platelets:</strong> Platelets in the blood (kiloplatelets/mL)</li>
                <li><strong>Serum Creatinine:</strong> Level of serum creatinine in the blood (mg/dL)</li>
                <li><strong>Serum Sodium:</strong> Level of serum sodium in the blood (mEq/L)</li>
                <li><strong>Sex:</strong> Woman or man. 0 as woman; 1 as man</li>
                <li><strong>Smoking:</strong> If the patient smokes or not. 0 as no-smoking; 1 otherwise</li>
                <li><strong>Time:</strong> Follow-up period</li>
                <li><strong>Death Event:</strong> If the patient died during the follow-up period. 0 as survived; 1 as dead</li>
              </ul>
             <p>Download the data <a href='https://archive.ics.uci.edu/dataset/519/heart+failure+clinical+records'>here</a>.</p>")
             )
             
             ),
    tabPanel("Plot & Summary",
             sidebarLayout(
               sidebarPanel(
                 selectInput("variable", "Choose the variable",
                             choices = colnames(df1[, !names(df1) %in% c("DEATH_EVENT", "logplatelets", "logcreatinine_phosphokinase")])),
                 hr(),
                 p("This is a Shiny app to display a custom plot and summary table based on user selection."),
                 p("Please choose a variable from the dropdown menu to explore.")
               ),
               mainPanel(
                 plotOutput("plot"),
                 br(),
                 tableOutput("summary")
               )
             )
           ),
    tabPanel("Prediction",
             sidebarLayout(
               sidebarPanel(
                 # Numeric input fields with labels
                 numericInput("age", "Enter Age:", value = 50, min = 1, max = 100),
                 numericInput("creatinine_phosphokinase", "Enter CPK Level (mcg/L):", value = 50),
                 numericInput("ejection_fraction", "Enter Ejection Fraction (%):", value = 50),
                 numericInput("time", "Enter Follow-up Period:", value = 50),
                 numericInput("platelets", "Enter Platelets (kiloplatelets/mL):", value = 50),
                 numericInput("serum_sodium", "Enter Serum Sodium (mEq/L):", value = 50),
                 numericInput("serum_creatinine", "Enter Serum Creatinine (mg/dL):", value = 50),
                 selectInput("anaemia", "Has Anaemia?", choices = c("Yes", "No")),
                 selectInput("diabetes", "Has Diabetes?", choices = c("Yes", "No")),
                 selectInput("high_blood_pressure", "Has High Blood Pressure?", choices = c("Yes", "No")),
                 selectInput("sex", "Gender:", choices = c("Woman", "Man")),
                 selectInput("smoking", "Does the patient smoke?", choices = c("Yes", "No")),
                 actionButton("predictBtn", "Predict", class = "btn-primary")
               ),
               mainPanel(
                 # Prediction result
                 h4("Prediction Result:"),
                 textOutput("prediction")
               )
             ))
         )
      )
  

# Shiny Server
server <- function(input, output, session) {
  output$plot <- renderPlot({
    plot_custom(data = df1, y = input$variable)
  })
  
  output$summary <- renderTable({
    data_summary(data = df1, y = input$variable)
  })
  output$description<-renderText({
    paste("This is a dataset description")
  })
  prediction_df<-reactive({
    round(predict(logistic_regression,tibble(
      age=input$age,
      creatinine_phosphokinase= input$creatinine_phosphokinase,
      ejection_fraction=input$ejection_fraction,
      time=input$time,
      platelets=input$platelets,
      serum_sodium=input$serum_sodium,
      serum_creatinine=input$serum_creatinine,
      anaemia=ifelse(input$anaemia=="Yes","1","0"),
      diabetes=ifelse(input$diabetes=="Yes","1","0"),
      high_blood_pressure=ifelse(input$high_blood_pressure=="Yes","1","0"),
      sex=ifelse(input$sex=="Woman","0","1"),
      smoking=ifelse(input$smoking=="Yes","1","0"),
      logcreatinine_phosphokinase=log(input$creatinine_phosphokinase),
      logplatelets=log(input$platelets)
),type="response"),4)
  })
  output$prediction <- renderText({
    if (input$predictBtn > 0) {
      paste("Survival rate of this patient is:", as.numeric(1-prediction_df()))
    }
  })
  
  # Observe the click event of the "Predict" button
  observeEvent(input$predictBtn, {
    # Perform any additional actions when the button is clicked
    # You can add more logic or actions here
  })
}

# Run the app
shinyApp(ui, server)

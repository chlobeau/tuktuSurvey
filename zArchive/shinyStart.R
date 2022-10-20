#load libraries
require(shiny)
require(shinysurveys)
#require(shinydashboard)
require(googlesheets4)
#require(DT)

# survey
# Define questions in the format of a shinysurvey
survey_questions <- data.frame(
  question = c("What is your email?",
               "Observer"),
  option = NA,
  input_type = "text",
  input_id = c("email", "observer"),
  dependence = NA,
  dependence_value = NA,
  required = c(TRUE, FALSE)
)

# Define shiny UI
ui <- fluidPage(
  titlePanel("Shiny suvey test!"),
  
  sidebarLayout(
    sidebarPanel("sidebar panel"),
    mainPanel(
      h1("A demo form for collecting TK observations"),
      textInput("email", "Email"),
      dateInput("date", 
                h3("Date input")),
      textInput("observer", 
                h3("Observer name")),
      radioButtons("country", "Country",
                   choices = list("Canada","US"))
      
    )
  )
  
)

# Define shiny server
#use shinyvalidate
require(shinyvalidate)

server <- function(input, output, session) {
  renderSurvey()
  
  observeEvent(input$submit, {
    response_data <- getSurveyData()
  
    
    })
  # Validation rules are set in the server, start by
  # making a new instance of an `InputValidator()`
  iv <- InputValidator$new()
  
  # Basic usage: `sv_email()` works well with its
  # defaults; a message will be displayed if the
  # validation of `input$email` fails
  iv$add_rule("email", sv_email())
  
  # Finally, `enable()` the validation rules
  iv$enable()
}

# Run the shiny application
shinyApp(ui, server)



survey_df <- read.csv("surveyQs.csv")

require(shiny)
require(shinysurveys)

# add date input
extendInputType("date", {
  shiny::dateInput(
    inputId = surveyID(),
    value = NA,
    label = surveyLabel(),
    max = Sys.Date()+10
  )
})

extendInputType("checkboxGroup", {
  shiny::checkboxGroupInput(
    inputId = surveyID(),
    label = surveyLabel(),
    choices = surveyOptions()
    )
})

ui <- shiny::fluidPage(
  shinysurveys::surveyOutput(df = survey_df,
                             survey_title = "A minimal title",
                             survey_description = "A minimal description")
)

server <- function(input, output, session) {
  shinysurveys::renderSurvey()
}

shiny::shinyApp(ui = ui, server = server)

?shinysurveys::renderSurvey

summary(survey_df)

## authenticating google 
# https://www.jdtrat.com/blog/connect-shiny-google/

#install.packages('rsconnect')
rsconnect::setAccountInfo(name='fotcaribou',
                          token='F00EA60F5B1952793DD0534FF2075FD7',
                          secret='fwaoPXkaKyZn81leW4OWNkYmhIZyfyJAGQTnbTFO')

require(rsconnect)


options(
  # whenever there is one account token found, use the cached token
  gargle_oauth_email = TRUE,
  # specify auth tokens should be stored in a hidden directory ".secrets"
  gargle_oauth_cache = "C:/R/tkSurvey/.secrets"
)

# Run once on set up
googlesheets4::gs4_create(name = "survey-test", 
                          # Create a sheet called main for all data to 
                          # go to the same place
                          sheets = "main")

# Get the ID of the sheet for writing programmatically
# This should be placed at the top of your shiny app
sheet_id <- googledrive::drive_get("survey-test")$id

# Define shiny server with google sheet id
require(googlesheets4)
server <- function(input, output, session) {
  shinysurveys::renderSurvey()
  
  observeEvent(input$submit, {
    response_data <- getSurveyData()
    
    # Read our sheet
    values <- read_sheet(ss = sheet_id, 
                         sheet = "main")
    
    # Check to see if our sheet has any existing data.
    # If not, let's write to it and set up column names. 
    # Otherwise, let's append to it.
    
    if (nrow(values) == 0) {
      sheet_write(data = response_data,
                  ss = sheet_id,
                  sheet = "main")
    } else {
      sheet_append(data = response_data,
                   ss = sheet_id,
                   sheet = "main")
    }
    
  })
  
}

shiny::shinyApp(ui, server)

#https://nirzaree.wordpress.com/2020/10/11/building-a-webapp-for-data-collection-visualization-using-r-shiny/

#https://psyteachr.github.io/shiny-tutorials/data-input.html

# Setting up basic flow of the app
require(shiny)
require(tidyverse)

# Define questions

email <- textInput(
  "email",
  "Your email:",
  value = ""
)

document <- textInput(
  "document",
  "Document title (e.g. Western Arctic Caribou Herd Working Group"
)

herd <- checkboxGroupInput(
  "herd",
  "Herd",
  choices = c("Western Arctic", "Central Arctic", "Porcupine", 
              "Cape Bathurst", "Bluenose West", "Bluenose East", "Bathurst",
              "Beverly Ahiak", "Qamanirjuaq", "Wager Bay", "Lorillard")
)

territories_df <- data.frame(COUNTRY = c("Unknown", "US",
                                         "Canada", "Canada", "Canada", "Canada", "Canada", 
                                         "Canada", "Canada", "Canada", "Canada"), 
                             TERRITORIES = c("", "Alaska",
                                             "Yukon", "NWT", "Nunavut", "Quebec", "Newfoundland",
                                             "Prince Edward Isalnd", "Nova Scotia", "New Brunswick", "Unknown"))

country <- selectInput(
  "country",
  "Country",
  choices = unique(territories_df$COUNTRY)
)

territory <- selectInput(
  "territory",
  "Territory",
  choices = NULL
)

observer_name <- textInput(
  "observer_name",
  "Name of observer, if provided"
)

role_check <- radioButtons(
  "role_check",
  "Role of observer, if provided",
  c("Not provided",
    "Community member",
    "Researcher"
    )
)

date_reported <- dateInput(
  "date_reported",
  "Date of reporting",
  max = Sys.time(),
  startview = "year")

quote_text <- textAreaInput(
  "quote_text",
  "Quote (Copy the text of the observation directly)",
  rows = 6
  
)
# use shinyvalidate on quote_text and email

page_number <- numericInput(
  "page_number",
  "Page number",
  value = NA,
  min = 1
)

line_number <- numericInput(
  "line_number",
  "Line number",
  value = NA,
  min = 1
)

environment_keywords <- checkboxGroupInput(
  "environment_keywords",
  "Environment keywords",
  choices = c("Weather", "Snow", "Ice", "Rain", "Vegetation", "Wolves", "Bears", "Water crossing", "Wind")
)

other_environment <- textInput(
  "other_environment",
  "Other environment keywords, separate by comma"
)

human_keywords <- checkboxGroupInput(
  "human_keywords",
  "Human keywords",
  choices = c("Mining", "Harvest", "Roads")
)

other_human <- textInput(
  "other_human",
  "Other human impact keywords, separate by comma"
)

caribou_keywords <- checkboxGroupInput(
  "caribou_keywords",
  "Caribou keywords",
  choices = c("Migration", "Calves", "Cows", "Bulls", "Rut", "Body condition", "Historic abundance", "Current abundance", "Mortality")
)

other_keywords <- checkboxGroupInput(
  "other_keywords",
  "Other keywords",
  choices = c("Worms", "Flies", "Disease")
)

other_text <- textInput(
  "other_keywords",
  "Any other important keywords, separate by comma"
)

season <- checkboxGroupInput(
  "season",
  "Season",
  choices = c("Summer", "Winter")
)

comments <- textInput(
  "comments",
  "Comments"
)



# functions
resetForm <- function(session) {
  # reset values
  updateTextInput(session, c("observer_name", "other_environment", "other_human", "other_text", "comments"))
  updateCheckboxGroupInput(session, "role_check", "herd", "environment_keywords", "human_keywords", "caribou_keywords", "other_keywords", "season" )
  updateTextAreaInput(session, "quote")
  updateRadioButtons(session, "r_num_years")
  updateDateInput(session, "date_reported")
  updateNumericInput(sesssion, "page_number", "line_number")
}


ui <- fluidPage(
  title = "Questionnaire Framework",
  
  # App title ----
  h3("Caribou meeting notes observations"),
  
  h4("Meeting notes"), #maybe make this a sidebar
  fluidRow(
    column(width=6, document)
    ,column(width=6, country)
    ,column(width=6, territory)
    ,column(width=6, herd)
    ,column(width=6, email)
  ),
  h4("Quote"),
  fluidRow(
    column(width=6, observer_name),
    column(width=6, role_check),
    column(width=6, date_reported)
    ,column(width=6, quote_text)
    ,column(width=6, page_number)
    ,column(width=6, line_number)
    ,column(width=6, environment_keywords)
    ,column(width=6, other_environment)
    ,column(width=6, human_keywords)
    ,column(width=6, other_human)
    ,column(width=6, caribou_keywords)
    ,column(width=6, other_keywords)
    ,column(width=6, other_text)
    ,column(width=6, season)
    ,column(width=6, comments)
  )
  

)

server = function(input, output, session) {
  
  # create reactive country() that contains rows 
  #from territories_df that match the selected country
  country <- reactive({
    #req(input$country)
    filter(territories_df, COUNTRY == input$country)
  })
  observeEvent(country(), {
    choices <- unique(country()$TERRITORIES)
    updateSelectInput(inputId = "territory", choices = choices)
  })
  
  }

shinyApp(ui, server)

ui <- fluidPage(
  titlePanel("Caribou TK data collection form"
             ),#, style = "position:fixed",
  
  sidebarLayout(
    sidebarPanel(
      h4("Meeting notes"),
      document,
      country,
      territory,
      herd,
      email
      #actionButton("clearbutton", "Clear")
      , width = 3
    
      ),
    mainPanel(
      h4("Quote"),
      quote_text,
      observer_name,
      role_check,
      date_reported,
      page_number,
      line_number,
      environment_keywords,
      other_environment,
      human_keywords,
      other_human,
      caribou_keywords,
      other_keywords,
      other_text,
      season,
      comments
      , actionButton("submit", "Submit")
      , width = 9
      )
  )
)

server = function(input, output, session) {
  
  # create reactive country() that contains rows 
  #from territories_df that match the selected country
  country <- reactive({
    #req(input$country)
    filter(territories_df, COUNTRY == input$country)
  })
  observeEvent(country(), {
    choices <- unique(country()$TERRITORIES)
    updateSelectInput(inputId = "territory", choices = choices)
  })
  
  observeEvent(input$submit, {
    saveData(input)
  })
  
  
}
shinyApp(ui, server)

# saving data

# output directory
outputDir <- "responses"

# Define the fields we want to save from the form
fields <- c("email", "caribou_keywords", "page_number")

saveData <- function(input) {
  # put variables in a data frame
  data <- data.frame(matrix(nrow=1,ncol=0))
  for (x in fields) {
    var <- input[[x]]
    if (length(var) > 1 ) {
      # handles lists from checkboxGroup and multiple Select
      data[[x]] <- list(var)
    } else {
      # all other data types
      data[[x]] <- var
    }
  }
  data$submit_time <- date()
  
  # Create a unique file name
  fileName <- sprintf(
    "%s_%s.rds", 
    as.integer(Sys.time()), 
    digest::digest(data)
  )
  
  # Write the file to the local system
  saveRDS(
    object = data,
    file = file.path(outputDir, fileName)
  )
}

loadData <- function() {
  # read all the files into a list
  files <- list.files(outputDir, full.names = TRUE)
  
  if (length(files) == 0) {
    # create empty data frame with correct columns
    field_list <- c(fields, "submit_time")
    data <- data.frame(matrix(ncol = length(field_list), nrow = 0))
    names(data) <- field_list
  } else {
    data <- lapply(files, function(x) readRDS(x)) 
    
    # Concatenate all data together into one data.frame
    data <- do.call(rbind, data)
  }
  
  data
  
}

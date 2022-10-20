#https://nirzaree.wordpress.com/2020/10/11/building-a-webapp-for-data-collection-visualization-using-r-shiny/

#https://psyteachr.github.io/shiny-tutorials/data-input.html

# Setting up basic flow of the app
require(shiny)
require(tidyverse)

# Define questions ----

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
  "other_text",
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


# save data with smaller survey ----
ui <- fluidPage(
  titlePanel("Caribou TK data collection form"
             ),#, style = "position:fixed",
  
  DT::dataTableOutput("responses"),
  
      document,
      country,
      territory,
      herd,
      email,
  actionButton("submit", "Submit")
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
  
  formData <- reactive({
    data <- sapply(fields, function(x) input[[x]])
    data
  })
  
  # When the Submit button is clicked, save the form data
  observeEvent(input$submit, {
    saveData(formData())
  })
  
  
}


# saving data

# output directory
outputDir <- "responses"

# Define the fields we want to save from the form
fields <- c("document",
            "country",
            "territory",
            "herd",
            "email")

saveData <- function(data) {
  data <- t(data)
  # Create a unique file name
  fileName <- sprintf("%s_%s.rds", as.integer(Sys.time()), digest::digest(data))
  # Write the file to the local system
  saveRDS(
    object = data,
    file = file.path(outputDir, fileName)
    #row.names = FALSE, quote = TRUE
  )
}

shinyApp(ui, server)

# load saved data

loadData <- function(outputDir) {
  # Read all the files into a list
  files <- list.files(outputDir, full.names = TRUE)
  data <- lapply(files, function(x) readRDS(x)) 
  # Concatenate all data together into one data.frame
  data <- do.call(rbind, data)
  data
}

df <- loadData("responses")

# try with all survey questions ----


ui <- fluidPage(
  titlePanel("Caribou TK data collection form"
  ),#, style = "position:fixed",
  
  DT::dataTableOutput("responses"),
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
  
  formData <- reactive({
    data <- sapply(fields, function(x) input[[x]])
    data
  })
  
  # When the Submit button is clicked, save the form data
  observeEvent(input$submit, {
    saveData(formData())
  })
  
  
}


# saving data

# output directory
outputDir <- "responses2"

# Define the fields we want to save from the form
fields <- c("document",
            "country",
            "territory",
            "herd",
            "email",
            "quote_text",
            "observer_name",
            "role_check",
            "date_reported",
            "page_number",
            "line_number",
            "environment_keywords",
            "other_environment",
            "human_keywords",
            "other_human",
            "caribou_keywords",
            "other_keywords",
            "other_text",
            "season",
            "comments")

saveData <- function(data) {
  data <- t(data)
  # Create a unique file name
  fileName <- sprintf("%s_%s.rds", as.integer(Sys.time()), digest::digest(data))
  # Write the file to the local system
  saveRDS(
    object = data,
    file = file.path(outputDir, fileName)
    #row.names = FALSE, quote = TRUE
  )
}

shinyApp(ui, server)

loadData <- function(outputDir) {
  # Read all the files into a list
  files <- list.files(outputDir, full.names = TRUE)
  data <- lapply(files, function(x) readRDS(x)) 
  # Concatenate all data together into one data.frame
  data <- do.call(rbind, data)
  data
}

df <- loadData("responses2")

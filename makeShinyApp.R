require(shiny)
require(tidyverse)

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

# saving data locally ----

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

# Define survey questions ----

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

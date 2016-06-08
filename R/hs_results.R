# Exported functions ----

# Internal functions ----

num_results <- function(hs_response) {
  list_results(hs_response)$total
}

hs_content <- function(hs_response) {
  httr::content(hs_response, as = "text")
}

# Return flattened results
list_results <- function(hs_response) {
  jsonlite::fromJSON(hs_content(hs_response), flatten = TRUE)
}

# Input checking ----

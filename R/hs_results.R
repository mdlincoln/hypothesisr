# Exported functions ----

#' Number of results from a search
#' @export
num_results <- function(hs_response) {
  hs_content(hs_response)$total
}

list_results <- function(hs_response) {
  hs_content(hs_response)
}

# Internal functions ----

hs_content <- function(hs_response) {
  httr::content(hs_response)
}

# Input checking ----
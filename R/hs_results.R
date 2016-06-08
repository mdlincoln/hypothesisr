# Exported functions ----

#' Number of results from a search
#' @export
num_results <- function(hs_response) {
  hs_content(hs_response)$total
}

#' Dataframe of annotations
#'
#' @export
hs_as_data_frame <- function(hs_response) {
  lapply(hs_response, hs_content)
}

# Internal functions ----

hs_content <- function(hs_response) {
  httr::content(hs_response)
}

list_results <- function(hs_response) {
  hs_content(hs_response)
}

# Input checking ----

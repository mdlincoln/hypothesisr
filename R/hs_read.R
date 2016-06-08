# Exported functions ----

#' Retrieve a single annotation by ID
#'
#' @param id Character. A hypothes.is annotation id.
#'
#' @return A dataframe with the contents of that annotation.
#'
#' @export
#' @examples
#' hs_read("Zzx_RC2cEeaSN18iqoj6Aw")
hs_read <- function(id) {
  hs_read_response <- hs_read_handler(id)
  hs_read_results(hs_read_response)
}

# Internal functions ----

# Internal handler that constructs and fires the appropriate URL.
hs_read_handler <- function(id) {

  # Check that id is a 22-character string
  is_valid_id(id)

  hs_base_url_list$path <- paste0("api/annotations/", id)

  formatted_url <- httr::build_url(hs_base_url_list)

  # GET the URL
  httr::GET(formatted_url, httr::accept_json())
}

# Hacky as all get-out: Wraps the returned json object in brackets so that
# jsonlite::fromJSON will produce a dataframe instead of a list
hs_read_results <- function(hs_read_response) {
  jsonlite::fromJSON(
    paste0("[", httr::content(hs_read_response, as = "text"), "]"))
}

# Input validation ----

is_valid_id <- function(id) {
  stopifnot(nchar(id) == 22)
}

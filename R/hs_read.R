# Exported functions ----

#' Retrieve a single annotation by ID
#'
#' @param id Character. A hypothes.is annotation id.
#'
#' @return A dataframe with the contents of that annotation.
#'
#' @export
#' @examples
#' hs_read("WFMnSC3FEeaNvLeGkQeJbg")
#' @source \url{https://h.readthedocs.io/en/latest/api/#read}
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

  status_code <- as.character(httr::status_code(hs_read_response))

  read_action <- function(response, code) {
    switch (code,
            "200" = jsonlite::fromJSON(paste0("[", httr::content(response, as = "text"), "]")),
            "404" = stop("404: annotation with the given id was not found"),
            stop("Hypothes.is sent an undocumented response code. Sorry!")
    )
  }

  read_action(hs_read_response, status_code)
}

# Input validation ----

is_valid_id <- function(id) {
  stopifnot(nchar(id) %in% c(20, 22))
}

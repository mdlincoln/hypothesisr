# Exported functions ----

#' Delete an annotation
#'
#' @param token Character. Your account token, which you can generate at \url{https://hypothes.is/register}
#' @param id Character. A hypothes.is annotation id.
#'
#' @return TRUE on successful deletion.
#' @source \url{https://h.readthedocs.io/en/latest/api/#delete}
#'
#' @export
hs_delete <- function(token, id) {
  hs_delete_response <- hs_delete_handler(token, id)
  hs_delete_results(hs_delete_response)
}

# Internal functions ----

hs_delete_handler <- function(token, id) {

  # Check token validity
  is_valid_token(token)
  is_valid_id(id)

  # Format the url to post to
  hs_base_url_list$path <- paste0("api/annotations/", id)
  formatted_url <- httr::build_url(hs_base_url_list)

  # Post the JSON data with the authorization token
  httr::DELETE(formatted_url, httr::add_headers(Authorization = paste0("Bearer ", token)))
}

# Check the response code after deletion. If 200, return TRUE. If otherwise,
# throw an error.
hs_delete_results <- function(hs_delete_response) {
  status_code <- as.character(httr::status_code(hs_delete_response))

  delete_action <- function(response, code) {
    switch (code,
            "200" = TRUE,
            "401" = stop("401: no API token was provided"),
            "403" = stop("403: API token provided does not convey 'update' permissions for the annotation with the given id"),
            "404" = stop("404: annotation with the given id was not found"),
            stop("Hypothes.is sent an undocumented response code. Sorry!")
    )
  }

  delete_action(hs_delete_response, status_code)
}


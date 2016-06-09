# Exported functions ----

#' Create annotations
#'
#' @param token Character. Your account token, which you can generate at \url{https://hypothes.is/register}
#' @param uri Character. The URI to be annotated.
#' @param user Character. Your user account, normally in the format \code{acct:username@hypothes.is}
#' @param permissions A named list with read, update, delete, and admin permissions. Defaults to setting global read permissions (\code{group:__world__}) and setting the \code{user} string for update, delete, and admin permissions.
#' @param document A list describing the document. CURRENTLY IGNORED.
#' @param target A list describing the highlight position of the annotation. CURRENTLY IGNORED
#' @param tags Character. (optional) Tags to apply to the annotation.
#' @param text Character. Text to put in the body of the annotation. This will be coerced into a character vector of length 1 using \link{paste}.
#' @param custom Add arbitrary fields to the JSON object submitted to hypothes.is by means of a named list.
#'
#' @return Upon successful creation, returns a 22-character annotation ID. This ID may be retrieved using \link{hs_read}.
#'
#' @export
#' @source \url{https://h.readthedocs.io/en/latest/api/#create}
#' @examples
#' \dontrun{
#' hs_create(token = user_token,
#' uri = "https://github.com/mdlincoln/hypothesisr",
#' user = "acct:mdlincoln@hypothes.is", tags = c("testing", "R"),
#' text = "R made me!")
#' }
hs_create <- function(token, uri, user,
                      permissions = list(read = "group:__world__",
                                         update = user, delete = user,
                                         admin = user),
                      document = NULL, target = NULL, tags = NULL, text,
                      custom = NULL) {

  hs_create_response <- hs_create_handler(token, uri, user, permissions,
                                          document, target, tags,
                                          paste(text, collapse = "\n"), custom)

  hs_create_results(hs_create_response)
}

# Internal functions ----

hs_create_handler <- function(token, uri, user, permissions, document, target, tags, text, custom) {

  # Check token validity
  is_valid_token(token)

  create_json <- hs_construct_annotation(uri, user, permissions, tags, text, custom)

  # Format the url to post to
  hs_base_url_list$path <- "api/annotations"
  formatted_url <- httr::build_url(hs_base_url_list)

  # Post the JSON data with the authorization token
  httr::POST(formatted_url, body = create_json, httr::accept_json(),
    httr::content_type_json(),
    httr::add_headers(Authorization = paste0("Bearer ", token)))
}

# Constructs annotation JSON (may be used by a future hs_update_handler, hence
# the separate method)
hs_construct_annotation <- function(uri, user, permissions, tags, text, custom) {
  # Construct a list holding the annotation data, and parse into JSON
  if(is.null(custom)) {
    ann_list <- list()
  } else {
    ann_list <- custom
  }
  ann_list$uri <- jsonlite::unbox(uri)
  ann_list$user <- jsonlite::unbox(user)
  ann_list$permissions <- permissions
  ann_list$tags <- tags
  ann_list$text <- jsonlite::unbox(text)

  jsonlite::toJSON(ann_list)
}

# Check the response code after creation. If 200, return the new annotation ID.
# If otherwise, throw an error.
hs_create_results <- function(hs_create_response) {

  status_code <- as.character(httr::status_code(hs_create_response))

  create_action <- function(response, code) {
    switch (code,
            "200" = list_results(response)$id,
            "400" = stop("400: could not create annotation from your request (bad payload)"),
            "401" = stop("401: no API token was provided"),
            "403" = stop("403: API token provided does not convey 'create' permissions"),
            "404" = stop("404: API token is unrecognized"),
            stop("Hypothes.is sent an undocumented response code. Sorry!")
    )
  }

  create_action(hs_create_response, status_code)
}

# Input validation ----

# Check locally if the token is a 37-character string
is_valid_token <- function(token) {
  if(nchar(token) != 37)
    stop(token, " should be a 37-character string. See https://hypothes.is/profile/developer to generate your own token.")
}

# Exported methods ----

#' Update annotations
#'
#' @inheritParams hs_create
#' @param token Character. Your account token, which you can generate at \url{https://hypothes.is/register}.
#' @param id Character. A hypothes.is annotation id.
#'
#' @return TRUE on successful update.
#' @source \url{https://h.readthedocs.io/en/latest/api/#update}
#' @export
#' @examples
#' \dontrun{
#' hs_update(user_token, "lDf9rC3EEea6ck-G5kLdXA", text = "Now even more annotate-y!")
#' }
hs_update <- function(token, id, uri = NULL, user = NULL, permissions = NULL,
                      document = NULL, target = NULL, tags = NULL, text = NULL,
                      custom = NULL) {
  hs_update_response <- hs_update_handler(token, id, uri, user, permissions,
                                          tags, text, custom)
  hs_update_results(hs_update_response)
}

# Internal methods ----

hs_update_handler <- function(token, id, uri, user, permissions, tags, text,
                              custom) {
  is_valid_token(token)
  is_valid_id(id)

  update_json <- hs_construct_update(uri, user, permissions, tags, text, custom)

  # Format the url to post to
  hs_base_url_list$path <- paste0("api/annotations/", id)
  formatted_url <- httr::build_url(hs_base_url_list)

  # Post the JSON data with the authorization token
  httr::PUT(formatted_url, body = update_json, httr::accept_json(),
             httr::content_type_json(),
             httr::add_headers(Authorization = paste0("Bearer ", token)))
}

hs_construct_update <- function(uri, user, permissions, tags, text, custom) {
  if(!is.null(custom)) {
    update_list <- custom
  } else {
    update_list <- list()
  }
  if(!is.null(uri))
    update_list$uri <- jsonlite::unbox(uri)
  if(!is.null(user))
    update_list$user <- jsonlite::unbox(user)
  if(!is.null(permissions))
    update_list$permissions <- permissions
  if(!is.null(tags))
    update_list$tags <- tags
  if(!is.null(text))
    update_list$text <- jsonlite::unbox(text)

  jsonlite::toJSON(update_list)
}

# Check the response code after creation. If 200, return TRUE. If otherwise,
# throw an error.
hs_update_results <- function(hs_update_response) {

  status_code <- as.character(httr::status_code(hs_update_response))

  update_action <- function(response, code) {
    switch (code,
            "200" = TRUE,
            "400" = stop("400: could not update annotation from your request (bad payload)"),
            "401" = stop("401: no API token was provided"),
            "403" = stop("403: API token provided does not convey 'update' permissions"),
            "404" = stop("404: annotation with the given id was not found"),
            stop("Hypothes.is sent an undocumented response code. Sorry!")
    )
  }

  update_action(hs_update_response, status_code)
}

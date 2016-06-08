# Exported search functions ----

#' Search hypothes.is annotations
#'
#' Search hypothes.is annotations.
#'
#' @note If any vectors are passed to these arguments, only the first values
#'   will be used.
#'
#' @param limit Integer. The maximum number of annotations to return. (Default:
#'   20)
#' @param offset Integer The minimum number of initial annotations to skip. This
#'   is used for pagination. For example if there are 65 annotations matching
#'   our search query and we’re retrieving up to 30 annotations at a time, then
#'   to retrieve the last 5, set offset = 5. (Default = 0)
#' @param sort Character. Specify which field the annotations should be sorted
#'   by: \code{consumer}, \code{created}, \code{id}, \code{text},
#'   \code{updated}, \code{uri}, \code{user}.
#' @param order Character. Specify which order annotations should be sorted by:
#'   \code{asc} or \code{desc}.
#' @param uri Character. Search for annotations of a particular URI, for example
#'   \code{www.example.com}. URI searches will also find annotations of
#'   equivalent URIs. For example if the HTML document at
#'   \code{http://www.example.com/document.html?} includes a \code{<link
#'   rel="canonical" href="http://www.example.com/canonical_document.html">}
#'   then annotations of \code{http://www.example.com/canonical_document.html}
#'   will also be included in the search results. Other forms of document
#'   equivalence that are supported include \code{rel="alternate"} links, DOIs,
#'   PDF file IDs, and more.
#' @param user Character. Search for annotations by a particular user. For
#'   example, \code{tim} will find all annotations by users named \code{tim} at
#'   any provider, while \code{tim@hypothes.is} will only find annotations by
#'   \code{tim} on \code{hypothes.is}
#' @param text Character. Search for annotations whose body text contains some
#'   text, for example: \code{foobar}.
#' @param any Character. Search for annotations whose \code{quote}, \code{tags},
#'   \code{text}, \code{uri.parts} or \code{user} fields match some query text.
#'
#' @return Returns a list of results
#' @export
hs_search <- function(limit = 20, offset = 0, sort = "updated", order = "asc",
                      uri = NULL, user = NULL, text = NULL, any = NULL) {
  query_response <- hs_search_handler(limit[1], offset[1], sort[1], order[1],
                                      uri[1], user[1], text[1], any[1])
  httr::content(query_response)
}

# Internal search functions ----

# Internal handler that constructs and fires the appropriate URL.
hs_search_handler <- function(limit, offset, sort, order, uri, user, text, any) {

  # Check arguments for validity before making query
  is_valid_limit(limit)
  is_valid_offset(offset)
  is_valid_sort(sort)
  is_valid_order(order)

  # Construct a url from the query
  hs_base_url_list$path <- "api/search"
  hs_base_url_list$query$limit <- limit
  hs_base_url_list$query$offset <- offset
  hs_base_url_list$query$sort <- sort
  hs_base_url_list$query$order <- order
  hs_base_url_list$query$uri <- uri
  hs_base_url_list$query$user <- user
  hs_base_url_list$query$text <- text
  hs_base_url_list$query$any <- any
  formatted_url <- httr::build_url(hs_base_url_list)

  # GET the URL
  httr::GET(formatted_url, accept_json())
}

# Input checking ----

# Is the limit valid?
is_valid_limit <- function(limit) {
  if(!is.integer(limit) | !is.null(limit))
    stop("'limit' must be an integer")
}

# Is the offset valid?
is_valid_offset <- function(offset) {
  if(!is.integer(offset) | !is.null(offset))
    stop("'offset' must be an integer")
}

# Is the supplied sort field one of the acceptable fields?
is_valid_sort <- function(field) {

  valid_sorts <- c(
    "consumer",
    "created",
    "id",
    "text",
    "updated",
    "uri",
    "user",
    NULL)

  if(!(field %in% valid_sorts))
    stop(field, " is not the name of a field that hypothes.is can sort by. Please try one of the following: ", paste(valid_sorts, collapse = "; "))
}

# Is the supplied ordering valid?
is_valid_order <- function(field) {
  valid_orders <- c("asc", "desc", NULL)

  if(!(field %in% valid_orders))
    stop("hypothes.is cannot order in the direction ", field, ". Please use 'asc' or 'desc'")
}

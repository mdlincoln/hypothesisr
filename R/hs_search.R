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
#'   our search query and we're retrieving up to 30 annotations at a time, then
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
#' @param custom A named list of any field in the results returned by
#'   hypothes.is as a name, and the search text as values.
#'
#' @source \url{https://h.readthedocs.io/en/latest/api/#search}
#'
#' @return A dataframe with annotation data.
#' @examples
#' # Search for no more than 5 annotations containing the text "ulysses"
#' hs_search(text = "ulysses", limit = 5)
#' # Search with a custom field for tags
#' hs_search(custom = list(tags = "todo"))
#' # use the 'uri.parts' field to find annotations on a given domain (exclude
#' # the TLD, as this will result in all annotations on sites with, e.g., .org,
#' # as well.)
#' hs_search(custom = list(uri.parts = "programminghistorian"))
#' @export
hs_search <- function(limit = NULL, offset = NULL, sort = "updated", order = "asc",
                      uri = NULL, user = NULL, text = NULL, any = NULL, custom = list()) {
  query_response <- hs_search_handler(limit[1], offset[1], sort[1], order[1],
                                      uri[1], user[1], text[1], any[1], custom)
  hs_search_results(query_response)
}

#' Retreive all annotation search results as a data frame
#'
#' Takes the same arguments as \link{hs_search} and pages through all available
#' results, formatting the output as a data.frame.
#'
#' @inheritParams hs_search
#'
#' @param pagesize Integer. How many annotations to retrieve per query. Between 1 and 200. (Default: 200)
#' @param progress Boolean. Should a progress bar be displayed during download?
#'
#' @return A dataframe with annotation data.
#' @examples
#' \dontrun{
#' hs_search_all(text = "arxiv")
#' }
#' @export
hs_search_all <- function(sort = "updated", order = "asc", uri = NULL,
                          user = NULL, text = NULL, any = NULL, custom = list(), pagesize = 200,
                          progress = interactive()) {

  # pagesize <- validate_pagesize(pagesize)

  # Get a first page of results in order to assess how large the total download
  # will be
  first_page <- hs_search_handler(limit = pagesize, offset = 0, sort, order, uri,
                                  user, text, any, custom)

  total_results <- num_results(first_page)

  # If all the results are returned within the first page of values, the
  # function is finished.
  if(total_results <= pagesize)
    return(hs_search_results(first_page))

  # If not, we start paging.
  search_pages <- seq(0, total_results, by = pagesize)

  # If a progress bar is warranted, create it and return a paging function that
  # increments it; if not, just a plain paging function
  if(progress) {
    message("Downloading ", total_results, " annotations in ", length(search_pages), " pages.")
    pb <- utils::txtProgressBar(min = 0, max = total_results, initial = pagesize, style = 3)
    pager <- function(x) {
      utils::setTxtProgressBar(pb, x)
      hs_search_handler(limit = pagesize, offset = x, sort, order, uri, user, text,
                        any, custom)
    }
  } else {
    pager <- function(x) {
      hs_search_handler(limit = pagesize, offset = x, sort, order, uri, user, text,
                        any, custom)
    }
  }

  # Page through all results
  all_results <- lapply(search_pages, pager)

  # Close progress bar if needed
  if(exists("pb")) {
    utils::setTxtProgressBar(pb, total_results)
    close(pb)
  }

  hs_search_all_results(all_results, progress)
}

# Internal search functions ----

# Internal handler that constructs and fires the appropriate URL.
hs_search_handler <- function(limit, offset, sort, order, uri, user, text, any,
                              custom) {

  # Check arguments for validity before making query
  is_valid_limit(limit)
  is_valid_offset(offset)
  is_valid_sort(sort)
  is_valid_order(order)

  # Construct a url from the query
  hs_base_url_list$path <- "api/search"
  hs_base_url_list$query <- custom
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
  httr::GET(formatted_url, httr::accept_json())
}

hs_search_results <- function(hs_search_response) {

  res_list <- list_results(hs_search_response)
  res_total <- res_list$total
  res_df <- dplyr::as_data_frame(res_list$rows)
  res_rows <- nrow(res_df)
  attr(res_df, "hs_total_available") <- res_total

  if(res_total > res_rows)
    message("Your search result returned ", res_rows, " annotations, however ", res_total, " are available. Use hs_search_all to page through all possible results.")

  return(res_df)
}

hs_search_all_results <- function(hs_response, progress) {

  if(progress) {
    message("Parsing JSON response...")
    pb <- utils::txtProgressBar(min = 0, max = length(hs_response), initial = 1,
                                style = 3)
    listed_results <- lapply(hs_response, function(x) {
      utils::setTxtProgressBar(pb, value = utils::getTxtProgressBar(pb) + 1)
      list_results(x)
    })
    close(pb)
  } else {
    listed_results <- lapply(hs_response, list_results)
  }

  unlisted_results <- lapply(listed_results, function(x) {
    x$rows
  })

  dplyr::bind_rows(unlisted_results)
}

# Input checking ----

# Is the limit valid?
is_valid_limit <- function(limit) {
  if(!(is.numeric(limit) | is.null(limit)))
    stop("'limit' must be a whole number")
}

# Is the offset valid?
is_valid_offset <- function(offset) {
  if(!(is.numeric(offset) | is.null(offset)))
    stop("'offset' must be a whole number")
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
    "user")

  if(!(field %in% valid_sorts | is.null(field)))
    stop(field, " is not the name of a field that hypothes.is can sort by. Please try one of the following: ", paste(valid_sorts, collapse = "; "))
}

# Is the supplied ordering valid?
is_valid_order <- function(field) {
  valid_orders <- c("asc", "desc", NULL)

  if(!(field %in% valid_orders))
    stop("hypothes.is cannot order in the direction ", field, ". Please use 'asc' or 'desc'")
}

# Is the pagesize valid?
validate_pagesize <- function(pagesize) {
  if(!is.numeric(pagesize)) {
    stop("pagesize must be numeric")
  } else if(pagesize <= 0 | pagesize > 200) {
    warning("Coercing ", pagesize, " to integer.")
    return(as.integer(pagesize))
  }
}

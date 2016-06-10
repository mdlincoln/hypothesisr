#' hypothesisr: Wrapper for the Hypothes.is API
#'
#' Interact with the API for the web annotation service hypothes.is.
#' Allows users to add, search for, and retrieve annotation data.
#'
#' @docType package
#' @name hypothesisr
NULL

# Sets up the base url schema for all API queries to hypothes.is. Every API
# handler will append relevant queries and parameters to this list before
# formatting into a URL and GET/POST/PUT/DELETE-ing.
hs_base_url_list <- httr::parse_url("https://hypothes.is")

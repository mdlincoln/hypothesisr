#' Functions for opening an annotation in the system browser
#'
#' @param id Annotation ID.
#' @name open_
NULL

#' @describeIn open_ Open an annotation in context, displaying the original webpage with an annotation overlay
#' @export
open_context <- function(id) {
  is_valid_id(id)
  a <- hs_read(id)
  utils::browseURL(a$links$incontext)
}

#' @describeIn open_ Open an annotation on the hypothes.is webpage
#' @export
open_annotation <- function(id) {
  is_valid_id(id)
  a <- hs_read(id)
  utils::browseURL(a$links$html)
}

#' @describeIn open_ Open the original webpage to which the annotation links
#' @export
open_uri <- function(id) {
  is_valid_id(id)
  a <- hs_read(id)
  utils::browseURL(a$uri)
}

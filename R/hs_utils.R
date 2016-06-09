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
  if(is.null(a$links$incontext)) {
    warning("Annotation ", id, " has no context link. Defaulting to the annotation link.")
    link <- a$links$html
  } else {
    link <- a$links$incontext
  }
  utils::browseURL(link)
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

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

#' Create a reply to a comment
#'
#' This is a utility wrapper around \link{hs_create} that takes an original comment ID and creates a reply to it by adding the custom \code{references} field when constructing the annotation. Normal fields like
#'
#' @param token Character. Your account token, which you can generate at \url{https://hypothes.is/register}
#' @param user Character. Your user account, normally in the format \code{acct:username@hypothes.is}
#' @param id Character. The annotation ID to reply to.
#' @param text Character. Text to put in the body of the annotation. This will be coerced into a character vector of length 1 using \link{paste}.
#' @param ... Other arguments to pass to \link{hs_create}.
#'
#' @export
hs_reply <- function(token, user, id, text, ...) {
  original_ann <- hs_read(id)
  hs_create(token, uri = original_ann$uri, user = user, text = text,
            custom = list(references = id))
}

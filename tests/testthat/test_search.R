library(httr)
library(jsonlite)

context("Search hypothes.is")

test_that("Unparseable inputs cause errors.", {
  expect_error(hs_search(sort = "a"))
  expect_error(hs_search(order = "a"))
  expect_error(hs_search(sort = 1))
  expect_error(hs_search(order = 1))
  expect_error(hs_search(limit = "a"))
  expect_error(hs_search(offset = "a"))
})

test_that("hs_search returns a list of the expected format.", {

  hs_ulysses <- hs_search(text = "ulysses", limit = 5)

  expect_s3_class(hs_ulysses, "data.frame")
  expect_equivalent(nrow(hs_ulysses), 5)
  # The columns returned may differ depending on the exact search results,
  # however there are always a set of core fields that will be present
  expect_true(all(c("updated", "group", "target", "tags", "text", "created",
                    "uri", "user", "id", "references", "links.json",
                    "links.html", "links.incontext", "permissions.read",
                    "permissions.admin", "permissions.update",
                    "permissions.delete") %in% names(hs_ulysses)))
})

test_that("custom fields in hs_search are correctly added to URL.", {
  hs_custom <- hs_search(limit = 5, custom = list(tags = "todo"))
  expect_equivalent(nrow(hs_custom), 5)
})

test_that("Truncated results generate a message and table attribute.", {
  expect_message(hs_todo <- hs_search(text = "todo"))
  expect_is(attr(hs_todo, "hs_total_available"), "integer")
})

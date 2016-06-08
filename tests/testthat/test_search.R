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

  expect_type(hs_ulysses$total, "integer")
  expect_type(hs_ulysses$rows, "list")
  expect_equivalent(length(hs_ulysses$rows), 5)
  expect_equivalent(names(hs_ulysses$rows[[1]]), c("updated", "group", "target", "links", "tags", "text", "created", "uri", "user", "document", "id", "permissions"))
})

test_that("custom fields in hs_search are correctly added to URL.", {
  hs_custom <- hs_search(limit = 5, custom = list(tags = "todo"))

  expect_equivalent(length(hs_custom$rows), 5)
})

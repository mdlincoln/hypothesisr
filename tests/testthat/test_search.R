context("Search hypothes.is")

test_that("Unparseable inputs cause errors.", {
  expect_error(hs_search(sort = "a"))
  expect_error(hs_search(order = "a"))
  expect_error(hs_search(sort = 1))
  expect_error(hs_search(order = 1))
  expect_error(hs_search(limit = "a"))
  expect_error(hs_search(offset = "a"))
})

context("Search hypothes.is")

test_that("Unparseable inputs cause errors.", {
  expect_error(hs_search(sort = "a"))
  expect_error(hs_search(order = "a"))
  expect_error(hs_search(sort = 1))
  expect_error(hs_search(order = 1))
  expect_error(hs_search(limit = "a"))
  expect_error(hs_search(offset = "a"))
})

test_that("custom fields in hs_search are correctly added to URL.", {
  hs_custom <- hs_search(limit = 5, custom = list(tags = "todo"))

  expect_equivalent(length(hs_custom$rows), 5)
})

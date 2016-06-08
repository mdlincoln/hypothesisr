context("Create, read, update, and destroy hypothes.is annotations")

test_that("Annotations can be successfully created, read, updated, and destroyed.", {
  # Because all these actions require an API token, skip on CRAN
  skip_on_cran()

  test_token <- readRDS("token.rds")
  test_uri <- "https://github.com/mdlincoln/hypothesisr"
  test_user <- "acct:mdlincoln@hypothes.is"
  test_tags <- c("testing", "R")
  test_text <- "Temporary annotation made for package testing."

  create_id <- hs_create(token = test_token, uri = test_uri, user = test_user,
                         tags = test_tags, text = test_text)

  expect_equivalent(nchar(create_id), 22)
  expect_error(hs_create(token = "invalid", uri = test_uri, user = test_user,
                         tags = test_tags, text = test_text))

  hs_annotation <- hs_read(create_id)
  expect_s3_class(hs_annotation, "data.frame")
  expect_equivalent(nrow(hs_annotation), 1)
  expect_equivalent(hs_annotation$text, "Temporary annotation made for package testing.")

  expect_true(hs_update(test_token, create_id, text = "Updated annotation."))
  expect_equivalent(hs_read(create_id)$text, "Updated annotation.")

  expect_true(hs_delete(test_token, create_id))
  expect_error(hs_read(create_id), regexp = "404")
})

test_that("Illegal ids cause errors", {
  expect_error(hs_read("b"))
})

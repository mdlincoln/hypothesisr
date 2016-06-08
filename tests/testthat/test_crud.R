context("Create hypothes.is annotations")

test_that()


context("Read hypothes.is annotations")

test_that("Annotations can be retrieved", {
  hs_annotation <- hs_read("Zzx_RC2cEeaSN18iqoj6Aw")
  expect_s3_class(hs_annotation, "data.frame")
  expect_equivalent(nrow(hs_annotation), 1)
})

test_that("Illegal ids cause errors", {
  expect_error(hs_read("b"))
})

context("Update hypothes.is annotations")

context("Delete hypothes.is annotations")

## Test the general unit test function exported from this package

resetDummyManagedProvider()
verbose <- 0

test_that("testthat", {
    expect_error(
        provider <- DummyManagedProvider()
        ,NA)
    expect_error(
        container <- DummyWorkerContainer()
        ,NA)
    expect_error(
        generalDockerClusterTest(
            cloudProvider = provider,
            workerContainer = container,
            workerNumber = 5,
            testReconnect = TRUE,
            verbose = verbose)
        ,NA)
})

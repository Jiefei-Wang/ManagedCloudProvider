#' The root class for the managed cloud provider
#'
#' @field serverHandle Character(1), the server handle that can be recognized by the
#' cloud provider.
#' @field workerHandles Character(n), a list object for internal use only.
#' Please call `.getWorkerHandles(cluster)` to access the worker handles
#' @field workerPerHandle An internal counter. Please call `.getWorkerHandles(cluster)`
#' to access the worker handles
#' @exportClass ManagedCloudProvider
.ManagedCloudProvider <- setRefClass(
    "ManagedCloudProvider",
    fields = list(
        serverHandle = "character",
        workerHandles = "character",
        workerPerHandle = "integer"
    ),
    contains = "CloudProvider"
)

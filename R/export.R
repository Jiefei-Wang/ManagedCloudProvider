#' Add or get the worker container handles to the managed cloud provider
#'
#' Add or get the worker container handles to the managed cloud provider. The
#' handles can be duplicated if multiple workers share the same container
#'
#' @param provider A `ManagedCloudProvider` object
#' @param handles the worker container handles
#' @rdname managedHandles
#' @examples
#' ## make a dummy provider
#' DummyProvider <- setRefClass("DummyProvider", contains = "ManagedCloudProvider")
#' provider <- DummyProvider()
#'
#' ## No worker handle in the provider
#' getManagedWorkerHandles(provider)
#'
#' ## Add worker handles
#' addManagedWorkerHandles(provider, c("a", "b"))
#' getManagedWorkerHandles(provider)
#'
#' ## It is possible to add the same handle
#' ## if multiple workers share the same container
#' addManagedWorkerHandles(provider, c("a"))
#' getManagedWorkerHandles(provider)
#' @returns
#' addManagedWorkerHandles: No return value
#' getManagedWorkerHandles: A character vector of the worker handles
#' @export
addManagedWorkerHandles <- function(provider, handles){
    if(length(handles)!=0){
        allHandles <- c(getManagedWorkerHandles(provider), handles)
        info <- table(allHandles)
        provider$workerHandles <- names(info)
        provider$workerPerHandle <- as.vector(info)
        invisible(NULL)
    }
}


#' @rdname managedHandles
#' @export
getManagedWorkerHandles <- function(provider){
    workerHandles <- provider$workerHandles
    workerPerHandle <- provider$workerPerHandle
    x <- lapply(seq_along(workerHandles),
                function(i)rep(workerHandles[i],workerPerHandle[i])
    )
    unlist(x)
}

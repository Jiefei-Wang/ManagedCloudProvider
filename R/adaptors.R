#' Set the worker number in the cluster
#'
#' The developer should define `runDockerWorkerContainers`, `getDockerWorkerStatus`
#' and `killDockerWorkerContainers` instead.
#'
#' @inheritParams  DockerParallel::setDockerWorkerNumber
#' @param workerNumber Integer(1), the worker number to be set
#' @export
setMethod("setDockerWorkerNumber", "ManagedCloudProvider",
          function(provider, cluster, container, hardware, workerNumber, verbose)
          {
              verbosePrint(verbose, "Setting worker number to ", workerNumber)
              if(cluster$isServerRunning()){
                  ## set the expected worker number
                  removeDiedWorkers(cluster)

                  workerOffset <- workerNumber - getManagedWorkerNumber(provider)
                  if(workerOffset > 0){
                      addManagedWorkersInternal(cluster = cluster,
                                                container = container,
                                                hardware = hardware,
                                                workerNumber = workerOffset)
                  }
                  if(workerOffset < 0){
                      removeManagedWorkersInternal(cluster = cluster,
                                                   workerNumber = abs(workerOffset))
                  }
              }
          })

#' get the worker number in the cluster
#'
#' The developer should define `runDockerWorkerContainers`, `getDockerWorkerStatus`
#' and `killDockerWorkerContainers` instead.
#'
#' @inheritParams  DockerParallel::getDockerWorkerNumbers
#' @export
setMethod("getDockerWorkerNumbers", "ManagedCloudProvider", function(provider, cluster, verbose){
    if(cluster$isServerRunning()){
        workerStatus <- removeDiedWorkers(cluster)
        list(initializing = sum(provider$workerPerHandle[workerStatus=="initializing"]),
             running = sum(provider$workerPerHandle[workerStatus=="running"])
             )
    }else{
        list(initializing = 0L, running = 0L)
    }
})




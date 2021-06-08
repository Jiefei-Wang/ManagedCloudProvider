# Introduction
The managed cloud provider is a provider extension to the `DockerParallel` package. It aims to provide container management tools for the non-kubernetes cloud provider. The cloud provider only needs to define functions to run and stop the worker. The managed cloud provider can automatically scale the number of workers up or down according to the user's request. Below shows the structure of the managed cloud provider

![](vignettes/Inheritance.jpg)

where `CloudProvider` is the base class defined in `DockerParallel` package. `CloudProvider` dose nothing but define a few generics(the virtual class in C++ language)  .`ManagedCloudProvider` inherits from `CloudProvider`, it takes over the control of the worker container by defining the method for `setDockerWorkerNumber` and `getDockerWorkerNumbers`(The red font). The provider who inherits from `ManagedCloudProvider` does not need to manage the workers itself, it only needs to define the method for the generics exposed by `ManagedCloudProvider`, namely

1. runDockerWorkerContainers
2. getDockerWorkerStatus
3. IsDockerWorkerInitializing
4. IsDockerWorkerRunning
5. IsDockerWorkerStopped
6. killDockerWorkerContainers

The name should be self-explained. Please note that only `runDockerWorkerContainers`, `getDockerWorkerStatus` and `killDockerWorkerContainers` are required for making the provider works. The rest are optional and have the default methods(based on `getDockerWorkerStatus`). 

# runDockerWorkerContainers
`runDockerWorkerContainers` should deploy the worker on the cloud. The generic for `runDockerWorkerContainers` is 

```r
getGeneric("runDockerWorkerContainers")
#> nonstandardGenericFunction for "runDockerWorkerContainers" defined from package "ManagedCloudProvider"
#> 
#> function (provider, cluster, container, hardware, workerNumber, 
#>     verbose) 
#> {
#>     standardGeneric("runDockerWorkerContainers")
#> }
#> <bytecode: 0x000002161f812670>
#> <environment: 0x000002161f943478>
#> Methods may be defined for arguments: provider
#> Use  showMethods(runDockerWorkerContainers)  for currently available ones.
```
where `provider` is the cloud provider object and `cluster` is the `DockerCluster` object, `container` specifies which container should be used for the worker, `hardware` indicates the hardware requirement for each worker, `workerNumber` is the number of the workers that should be deployed. `verbose` is the verbose level. The return value of the function should be a character vector of length `workerNumber` with each element corresponding to a handle of a worker. The handle should be used to manage the lifecycle of the workers. It is possible to return the same handle for multiple workers if they share the same lifecycle(e.g. multiple workers share the same container). 
    
# getDockerWorkerStatus
`getDockerWorkerStatus` is for checking the status of the workers, a worker can have three possible status, namely `initializing`, `running` and `stopped`. The generic for `getDockerWorkerStatus` is

```r
getGeneric("getDockerWorkerStatus")
#> nonstandardGenericFunction for "getDockerWorkerStatus" defined from package "ManagedCloudProvider"
#> 
#> function (provider, cluster, workerHandles, verbose) 
#> {
#>     standardGeneric("getDockerWorkerStatus")
#> }
#> <bytecode: 0x0000021629794980>
#> <environment: 0x0000021629777048>
#> Methods may be defined for arguments: provider
#> Use  showMethods(getDockerWorkerStatus)  for currently available ones.
```
where `workerHandles` is a vector of handles returned by `runDockerWorkerContainers`, the elements of `workerHandles` are unique. The return value should be a character vector indicating the status of each worker.

The generics `IsDockerWorkerInitializing`, `IsDockerWorkerRunning` and `IsDockerWorkerStopped` check whether the worker is in a specific status. Once you have `getDockerWorkerStatus` defined these methods are automatically available. Therefore, you do not have to define them unless you have any faster implementation.

# killDockerWorkerContainers
`killDockerWorkerContainers` will kill the workers given the worker handles. If a handle is shared by multiple workers, all workers with the same handle should be killed. The generic is

```r
getGeneric("killDockerWorkerContainers")
#> nonstandardGenericFunction for "killDockerWorkerContainers" defined from package "ManagedCloudProvider"
#> 
#> function (provider, cluster, workerHandles, verbose) 
#> {
#>     standardGeneric("killDockerWorkerContainers")
#> }
#> <bytecode: 0x000002161fc45950>
#> <environment: 0x000002161fc7bd10>
#> Methods may be defined for arguments: provider
#> Use  showMethods(killDockerWorkerContainers)  for currently available ones.
```
The return value is a logical vector indicating whether the killing process is successful. Please note that the method should accept the invalid handle. That is, if the worker has already been killed or the handle does not exist, the method should not raise any error and the killing action should be denoted as successful. 





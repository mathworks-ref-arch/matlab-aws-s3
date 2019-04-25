# MATLAB Parallel Server

When using this package with MATLAB® Parallel Server note that S3™ objects cannot be serialized and thus cannot be passed between nodes as required, e.g. by a *parfor* call. If multiple workers are used to carry out S3 transactions then using *spmd* calls is an alternative approach. In many cases bandwidth between S3 and the Parallel Server cluster will be a limiting factor relative to bandwidth within the cluster and so doing uploads and downloads on a single node and sharing resulting MATLAB variables in the normal way may be a preferable comprise in terms of simplicity and performance.

Parallel Server is architecturally similar in many ways to the conventional MATLAB Desktop product. This package can be installed on a Parallel Server installation in the same way as it installed as for MATLAB Desktop as documented in: [Running on MATLAB Desktop](MATLABDesktop.md).   

Where central shared filesystem based installations are not used then each Parallel Server Worker must have the package installed.

[//]: #  (Copyright 2018 The MathWorks, Inc.)

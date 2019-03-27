# MATLAB Distributed Computing Server

When using this package with MATLAB® Distributed Computing Server (MDCS) note that S3™ objects cannot be serialized and thus cannot be passed between nodes as required by a *parfor* call. If  multiple workers are used to carry out S3 transactions then using *spmd* calls is an alternative approach. In many cases bandwidth between S3 and the MDCS cluster will be a limiting factor relative to bandwidth within the cluster as so doing uploads and downloads on a single node and sharing resulting MATLAB variables in the normal way may be a preferable comprise in terms of simplicity and performance.

MDCS is architecturally similar in many ways to the conventional MATLAB Desktop product. This package can be installed on an MDCS installation in the same way as it installed as for MATLAB Desktop as documented in: [Running on MATLAB Desktop](MATLABDesktop.md).   

Where central shared filesystem based installations are not used then each MDCS Worker must have the PSP installed. When installing interactively select *MATLAB Distributed Computing Server* as indicated. When using the non-interactive mode e.g.
```
$ sudo install.sh -s agreeToLicense -a ./AWS-release-0.2.1.zip -m /usr/local/MATLAB/R2017a -p mdcs -c /home/username/Downloads/UnlimitedJCEPolicyJDK7.zip
```
use *mdcs* as the product *-p* argument.

[//]: #  (Copyright 2018 The MathWorks, Inc.)

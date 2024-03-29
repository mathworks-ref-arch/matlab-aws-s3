# MATLAB Interface *for Amazon S3* - Release Notes

## Release 0.6.1 (4th Oct 2023)

* Added Multipart documentation

## Release 0.6.0 (23rd Aug 2023)

* Added multipart put, get & copy object (large file) support
  Object transfers > 100MB, now use TransferManager
* Updated pom.xml latest AWS 1.12.534 BOM, Jar file rebuild required if updating
* Bug fix to aws.s3.ObjectMetadata.getContentLength, now returns an int64 rather than a double *potentially breaking bug fix*

## Release 0.5.12 (3rd Mar 2023)

* Updated pom.xml latest AWS 1.12.150 BOM

## Release 0.5.11 (13th Dec 2021)

* Updated pom.xml latest AWS 1.12.128 BOM to include log4j updates
* Updated to JUNIT 4.3.2
* Updated Maven shade plug version

## Release 0.5.10 (22nd Mar 2021)

* Updated to support integration testing
* Documentation improvements

## Release 0.5.9 (13th Oct 2020)

* Bumped junit version

## Release 0.5.8 (5th Mar 2020)

* Updated security details
* Updated License

## Release 0.5.7 (9th Dec 2019)

* Added maven-compiler-plugin to pom.xml

## Release 0.5.6 (5th Nov 2019)

* Added ability to enable Path Style Access
* Added SSL Certificate checking documentation
* Documentation improvements

## Release 0.5.5 (Jun 2019)

* Documentation improvements

## Release 0.5.4 (21st Jun 2019)

* Updated security notice

## Release 0.5.3 (May 2019)

* Endpoint handling bug fix
* Bug fix to listTables logging

## Release 0.5.2 (Apr 2019)

* Documentation improvements
* Added get support to generatePresignedUrl()

## Release 0.5.1 (Feb 2019

* Documentation improvements

## Release 0.5.0 (Jan 2019)

* Changed license
* Removed SDK and scripts directory levels
* Added Grant object & associated methods
* Added getS3AccountOwner() client method
* getGrantsAsList() now returns a cell array of MATLAB Grant objects, *not backwardly compatible*
* Updated Permission object
* Documentation improvements
* Improved unit tests

## Release 0.4.2 (2nd Nov 2018)

* Fixed an issue for putObject in conjunction with compiled application.
* Added Objectmetadata class and methods
* Added support for a prefix with listObjects
* Moved version.txt from aws-common config to aws-s3 config directory

## Release 0.4.1 (11th Oct 2018)

* Minor bug fix in getObject
* Minor function name change in top level startup.m
* Fix to packaging of startup.m files

## Release 0.4.0 (20th Sep 2018)

* Removed non-S3 related functionality, now available in separate packages
* Added 3rd party License files directory: 3rdpartylicenses
* Updated installation process to reflect new structure
* Removed support for persisting and restoring variables directly, including *non-backwardly compatible changes to load, save, putObject and getObject*
* Removed unnecessary AWS SDK components from the jar file
* save and load now behave more like the built in save and load functional forms
* Updated and included pedestrian tracking example
* Built against v 1.11.367 of the AWS SDK

## Release 0.3.1 (18th May 2018)

* Credentials Provider Chain bug fixes
* Improved documentation
* listBuckets bug fix

## Release 0.3.0 (10th May 2018)

* *Note* The following calls are not backwardly compatible and require minor code changes, please review the relevant documentation; initialize(), client(), getObjectMetadata(), setProxyHost(), setProxyPassword(), setProxyPort(), setProxyUsername()
* Reorganized initialization process
* Updated documentation
* Updated installation process
* Enhanced and documented logging infrastructure, most logging now handled at verbose level, default is debug

## Release 0.2.9 (19th Mar 2018)

* Added support SSE-S3 encryption
* Improved automated document generation
* Added STS json credentials file writing script
* Fixed error handling in (un)install.sh
* Improved Installation documentation
* Improved startup.m path handling
* Fixed KMSCMK documentation errors

## Release 0.2.8 (27th Nov 2017)

* Reworked initialize() argument parsing
* Added experimental support for alternative S3 endpoints
* Added pdf documentation generation step

## Release 0.2.7 (10th Nov 2017)

* Bug fix to proxy settings handling
* Added a flag to disable checks running process in install and uninstall scripts

## Release 0.2.6 (31st Oct 2017)

* Added support for using proxy servers

## Release 0.2.5 (27th Oct 27 2017)

* Added support for temporary security credentials (session tokens)
* moved to release 1.11.221 of the AWS SDK

## Release 0.2.4 (22nd Aug 2017)

* Fixed a bug introduced in 0.2.3 which required cryptography in silent mode
* Updated documentation for MDCS and MPS

## Release 0.2.3 (22nd Aug 2017)

* listObjects() now handles no visible owner due to ACL restrictions
* Install and uninstall scripts now support macOS
* Install and uninstall scripts now support MPS (runtime) & MDCS
* Removed use of printf in bash scripts (not present in macOS)
* Removed requirement for bash version >= 4.2 to support macOS, now need >= 3.2
* macOS installation process now requires perl (perl ships with macOS)
* Fix to handling of README.txt in cryptography policy files

## Release 0.2.2 (18th Jul 2017)

* Consolidation and improvement of S3 documentation
* Robustness updates to installation and packaging scripts
* Added an uninstall script

## Release 0.2.1 (11th Jul 2017)

* credentials.json regions field must be of the form: "us-west-1" rather than "US_WEST_1"
* Added generatePresignedUrl(), generates pre-signed URLs for HTTP PUT
* Added isEC2(), tests if running in AWS EC2
* Added unlimitedCryptography(), tests if unlimited policy files are installed
* listObjects() now handles buckets with more than 1000 objects

## Release 0.2.0 (Jun 2017)

The following are the significant changes in this release:

* Added support for AWS Role based authentication when running on EC2
* Bug fixes
* A more robust install script with interactive and non-interactive modes
* Automated script based release packaging

## Release 0.1.0 (Jun 2017)

Initial release with support for:

* AWS Command Line Interface
* S3

[//]: #  (Copyright 2018-2023 The MathWorks, Inc.)

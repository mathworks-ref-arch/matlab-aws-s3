# Rebuilding the SDK

The jar files required by this package can be downloaded and built as follows. The package's *pom.xml* file can be found in: *Software/Java/*.

Use the following commands or OS specific equivalents to do a maven build of the package's jar file.
```
$ cd aws-s3/Software/Java
$ mvn clean verify package
```

The above pom file currently references version *1.11.367* of the AWS SDK:
```
<dependency>
  <groupId>com.amazonaws</groupId>
  <artifactId>aws-java-sdk-bom</artifactId>
  <version>1.11.367</version>
  <type>pom</type>
  <scope>import</scope>
</dependency>
```

To build with a more recent version of the SDK, amend the pom file to a specific version or use the following syntax to allow maven to select a newer version. Caution, this may result in build or runtime issues.
```
<dependency>
  <groupId>com.amazonaws</groupId>
  <artifactId>aws-java-sdk-bom</artifactId>
  <version>[1.11.367,)</version>
  <type>pom</type>
  <scope>import</scope>
</dependency>
```

The output of the build is a JAR file that is placed in *Software/MATLAB/lib/jar* folder for use by MATLAB.
-------------

[//]: #  (Copyright 2018 The MathWorks, Inc.)

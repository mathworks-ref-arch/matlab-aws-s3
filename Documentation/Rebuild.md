# Building the Interface

Before use it is required to build the jar file(s) required by this package using Maven™. The package's *pom.xml* file can be found in: *Software/Java/*. Maven requires that a JDK (Java® 7 or later) is installed and that the *JAVA_HOME* environment variable is set to the location of the JDK. On Windows® the *MAVEN_HOME* environment variable should also be set. Consult the Maven documentation for further details.

Use the following commands or OS specific equivalents to do a maven build of the package's jar file.
```
$ cd matlab-aws-s3/Software/Java
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

The output of the build is a JAR file that is placed in ```Software/MATLAB/lib/jar``` folder for use by MATLAB.

-------------

[//]: #  (Copyright 2018 The MathWorks, Inc.)

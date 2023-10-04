# Building the Interface

Before use it is required to build the jar file(s) required by this package using Maven™. The package's *pom.xml* file can be found in: *Software/Java/*. Maven requires that a JDK (Java® 7 or later) is installed and that the *JAVA_HOME* environment variable is set to the location of the JDK. On Windows® the *MAVEN_HOME* environment variable should also be set. Consult the Maven documentation for further details.

By default the pom.xml file targets Java 1.7 as supported by MATLAB R2017a and later.
This can be updated to 1.8 as supported by MATLAB R2017b and later by updating:

```xml
    <source>1.8</source>
    <target>1.8</target>
```

prior to running the `mvn clean package` command.

Use the following commands or operating system specific equivalents to do a maven build of the package's jar file.

```bash
cd matlab-aws-s3/Software/Java
mvn clean verify package
```

The above pom file currently references version *1.12.280* of the AWS SDK:

```xml
<dependency>
  <groupId>com.amazonaws</groupId>
  <artifactId>aws-java-sdk-bom</artifactId>
  <version>1.12.280</version>
  <type>pom</type>
  <scope>import</scope>
</dependency>
```

To build with a more recent version of the Amazon SDK, amend the pom file to a specific version or use the following syntax to allow maven to select a newer version. Caution, this may result in build or runtime issues.

```xml
<dependency>
  <groupId>com.amazonaws</groupId>
  <artifactId>aws-java-sdk-bom</artifactId>
  <version>[1.12.280,)</version>
  <type>pom</type>
  <scope>import</scope>
</dependency>
```

The output of the build is a JAR file that is placed in ```Software/MATLAB/lib/jar``` folder for use by MATLAB.

[//]: #  (Copyright 2018-2022 The MathWorks, Inc.)

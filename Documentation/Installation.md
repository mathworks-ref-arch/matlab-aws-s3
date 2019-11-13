# Installation

## Installing on Windows®, macOS® and Linux
The easiest way to install this package and all required dependencies is to clone the top-level repository using:

```bash
git clone --recursive https://github.com/mathworks-ref-arch/mathworks-aws-support.git
```

### Build the AWS SDK for Java components
The MATLAB code uses the AWS SDK for Java and can be built using:
```bash
cd matlab-aws-s3/Software/Java
mvn clean package
```
More details can be found here: [Build](Rebuild.md)

Once built, change directory to the ```Software/MATLAB``` folder and use the ```startup.m``` function to initialize the interface which will use the AWS Credentials Provider Chain to authenticate.
Please see the [relevant documentation](Authentication.md)
on options on how to specify the credentials.

The package is now ready for use. MATLAB can be configured to call ```startup.m``` on start if preferred so that the package is always available automatically. For further details see: [https://www.mathworks.com/help/matlab/ref/startup.html](https://www.mathworks.com/help/matlab/ref/startup.html)


[//]: #  (Copyright 2017 The MathWorks, Inc.)

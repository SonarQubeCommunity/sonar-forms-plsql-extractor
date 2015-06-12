Oracle Forms PL/SQL Extractor
=============================

Features
--------
This command-line gives the ability to extract PL/SQL source code from Oracle Forms. You can then feed SonarQube with the extracted PL/SQL source code.

Download
--------

Latest version is 1.1, released on 14 May 2014

http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/sonar-forms-plsql-extractor/1.1/sonar-forms-plsql-extractor-1.1-jar-with-dependencies.jar

Prerequisites
-------------
This extractor uses the Oracle JDAPI library that is included in the [Oracle Developer Suite](http://www.oracle.com/technetwork/developer-tools/developer-suite/downloads/index.html). Therefore a full installation of the Oracle Developer Suite is required. Once installed, check that the environment is correctly set:

The "PATH" environment variable must contain the Oracle Developer Suite paths, for example: ```PATH=C:/OracleDevSuite/jlib;C:/OracleDevSuite/bin;```

Use Java 1.6 or higher to run Sonar Forms PLSQL Extractor.

How to execute
--------------
Download the JAR file then execute:

```
set FORMS_PATH=C:\forms_project
java -DinputDir=C:\forms_project -DoutputDir=C:\extracted_plsql -cp C:\path\to\sonar-forms-plsql-extractor-1.1-jar-with-dependencies.jar;C:\path\to\oracle\forms\java\frmjdapi.jar org.sonar.oracleforms.plsql.PlSqlExtractor
```

Notes:
* The optional property ```formsExtensions``` is a comma-separated list of extensions of Oracle Forms files to extract. Its default value is ```fmb,mmb,olb,pll```.
* The output directory, as set by the outputDir property, must exist and is not cleaned up. Generated files override existing ones.

FAQ
---

Q : I'm getting "Exception in thread "main" java.lang.NoClassDefFoundError: Could not initialize class oracle.forms.jdapi.Jdapi" whilst my env variables and paths are correctly configured, why ?

A :  Oracle Developer Suite used to perform the extraction is available only for x32 OS. As a consequence, the Oracle Forms PL/SQL Extractor will work only on x32 OS.

How to build project [![Build Status](https://travis-ci.org/SonarCommunity/sonar-forms-plsql-extractor.svg?branch=master)](https://travis-ci.org/SonarCommunity/sonar-forms-plsql-extractor)
--------------------

The Java library frmjdapi is provided by the Oracle Developer Suite (see forms/java/frmjdapi.jar) and must be installed into the Maven repository :

```
mvn install:install-file  -Dfile=/path/to/frmjdapi.jar -DgroupId=com.oracle -DartifactId=frmjdapi -Dversion=10.0 -Dpackaging=jar
```

Then simply execute the following command. It does not require Oracle Developer Suite on the box:

```
mvn clean install
```

Medium tests are executed when enabling the profile "runMediumTests". Note that it requires the Oracle Dev Suite on the box:

```
mvn clean install -PrunMediumTests
```

License
-------

GNU LGPL v3

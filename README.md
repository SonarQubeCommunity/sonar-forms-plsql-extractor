Oracle Forms PL/SQL Extractor
=============================

This command-line extracts PL/SQL code from Oracle Forms sources.

How to run
----------

The PL/SQL extractor uses the Oracle JDAPI library that is included in the Oracle Developer Suite. Therefore, a full installation of the Oracle Developer Suite is required. Once installed, check that the environment is correctly set:

* The env variable PATH must contain the Oracle Developer Suite paths, for example:
  PATH=C:/OracleDevSuite/jdk/jre/bin/classic;C:/OracleDevSuite/jdk/jre/bin;C:/OracleDevSuite/jdk/jre/bin/client;C:/OracleDevSuite/jlib;C:/OracleDevSuite/bin;C:/oraclexe/app/oracle/product/10.2.0/server/bin
* The env variable ORACLE_HOME must contain the Oracle root path, for example:
  ORACLE_HOME=C:/oraclexe/app/oracle/product/10.2.0/server

Then execute the following command:
```
java -jar /path/to/sonar-forms-plsql-extractor-1.0-jar-with-dependencies.jar:/path/to/frmdapi.jar -DinputDir=/dir/contains/forms -DoutputDir=/path/to/plsql
```

The property 'formsExtensions' is optional. It's a comma-separated list of the extensions of Oracle Forms files. By default value is 'fmb,mmb,olb,pll'. The output directory, as set by the property outputDir, must exist and is not clean up. Generated files override existing ones.

How to build
------------

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

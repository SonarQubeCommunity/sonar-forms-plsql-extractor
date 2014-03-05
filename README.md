sonar-forms-plsql-extractor
===========================

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

The property 'formsExtensions' is optional. It's a comma-separated list of the extensions of Oracle Forms files. By default value is 'fmb,mmb,olb,pll'.

How to build
------------

TODO

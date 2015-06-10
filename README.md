Oracle Forms PL/SQL Extractor
=============================

This command-line extracts PL/SQL code from Oracle Forms sources.

How to run
----------

See http://docs.sonarqube.org/pages/viewpage.action?pageId=3671472

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

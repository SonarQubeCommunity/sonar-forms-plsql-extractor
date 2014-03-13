/*
 * Forms PL/SQL Extractor
 * Copyright (C) 2014 SonarSource
 * dev@sonar.codehaus.org
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02
 */
package org.sonar.oracleforms.plsql;

import org.apache.commons.io.FileUtils;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import static org.fest.assertions.Assertions.assertThat;

/**
 * This class requires Oracle Developer Suite and its Forms module to be installed
 * on the machine.
 * <p/>
 * Note that class name is suffixed by Testing but not Test in order to be excluded
 * by default build.
 */
public class MediumTesting {

  @Rule
  public TemporaryFolder temp = new TemporaryFolder();

  @Test
  public void extract_plsql_code_from_oracle_forms() throws Exception {
    File outputDir = temp.newFolder();
    Properties props = new Properties();
    props.setProperty("inputDir", new File("src/test/resources/org/sonar/oracleforms/plsql/MediumTest/sample").getAbsolutePath());
    props.setProperty("outputDir", outputDir.getAbsolutePath());

    PlSqlExtractor.create(props).run();

    List<File> generatedSqlFiles = new ArrayList<File>(FileUtils.listFiles(outputDir, new String[]{"sql"}, true));
    assertThat(generatedSqlFiles).hasSize(1);
    File sqlFile = generatedSqlFiles.get(0);
    assertThat(sqlFile.getCanonicalPath()).isEqualTo(new File(outputDir, "UE_SAMP/UE_SAMP_GUI.sql").getCanonicalPath());
    String sql = FileUtils.readFileToString(sqlFile);
    assertThat(sql)
        .isNotEmpty()
        .contains("Procedure UE_SAMP_ Is")
        .contains("-- path: /UE_SAMP/BLOCK1/ITEM3/PRE-TEXT-ITEM (TRIGGER)");
  }

  @Test
  public void extract_oracle_demo() throws Exception {
    File outputDir = temp.newFolder();
    Properties props = new Properties();
    props.setProperty("inputDir", new File("src/test/resources/org/sonar/oracleforms/plsql/MediumTest/oracle-demo").getAbsolutePath());
    props.setProperty("outputDir", outputDir.getAbsolutePath());

    PlSqlExtractor.create(props).run();

    List<File> generatedSqlFiles = new ArrayList<File>(FileUtils.listFiles(outputDir, new String[]{"sql"}, true));
    System.out.println(generatedSqlFiles);
  }

  @Test
  public void extract_oracle_bigraph() throws Exception {
    File outputDir = temp.newFolder();
    Properties props = new Properties();
    props.setProperty("inputDir", new File("src/test/resources/org/sonar/oracleforms/plsql/MediumTest/oracle-bigraph").getAbsolutePath());
    props.setProperty("outputDir", outputDir.getAbsolutePath());

    PlSqlExtractor.create(props).run();

    List<File> generatedSqlFiles = new ArrayList<File>(FileUtils.listFiles(outputDir, new String[]{"sql"}, true));
    System.out.println(generatedSqlFiles);
  }

  @Test
  public void extract_oracle_calendar() throws Exception {
    File outputDir = temp.newFolder();
    Properties props = new Properties();
    props.setProperty("inputDir", new File("src/test/resources/org/sonar/oracleforms/plsql/MediumTest/oracle-calendar").getAbsolutePath());
    props.setProperty("outputDir", outputDir.getAbsolutePath());

    PlSqlExtractor.create(props).run();

    List<File> generatedSqlFiles = new ArrayList<File>(FileUtils.listFiles(outputDir, new String[]{"sql"}, true));
    System.out.println(generatedSqlFiles);
  }

  @Test
  public void extract_oracle_featuredemo() throws Exception {
    File outputDir = temp.newFolder();
    Properties props = new Properties();
    props.setProperty("inputDir", new File("src/test/resources/org/sonar/oracleforms/plsql/MediumTest/oracle-featuredemo").getAbsolutePath());
    props.setProperty("outputDir", outputDir.getAbsolutePath());

    PlSqlExtractor.create(props).run();

    List<File> generatedSqlFiles = new ArrayList<File>(FileUtils.listFiles(outputDir, new String[]{"sql"}, true));
    System.out.println(generatedSqlFiles);
  }

  @Test
  public void forms_extensions_property() throws Exception {
    File outputDir = temp.newFolder();
    Properties props = new Properties();
    props.setProperty("inputDir", new File("src/test/resources/org/sonar/oracleforms/plsql/MediumTest/sample").getAbsolutePath());
    props.setProperty("outputDir", outputDir.getAbsolutePath());

    props.setProperty("formsExtensions", "forms,oracle");
    PlSqlExtractor.create(props).run();
    assertThat(FileUtils.listFiles(outputDir, new String[]{"sql"}, true)).isEmpty();

    props.setProperty("formsExtensions", "forms,fmb");
    PlSqlExtractor.create(props).run();
    assertThat(FileUtils.listFiles(outputDir, new String[]{"sql"}, true)).hasSize(1);
  }
}

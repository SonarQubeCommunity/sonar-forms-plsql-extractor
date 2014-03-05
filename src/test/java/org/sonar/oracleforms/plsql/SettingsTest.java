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
import java.util.Properties;

import static org.fest.assertions.Assertions.assertThat;
import static org.fest.assertions.Fail.fail;

public class SettingsTest {

  @Rule
  public TemporaryFolder temp = new TemporaryFolder();

  @Test
  public void dirs_must_exist() throws Exception {
    File input = temp.newFolder("forms-sources");
    File output = temp.newFolder("plsql-sources");
    Properties props = new Properties();
    props.setProperty("inputDir", input.getAbsolutePath());
    props.setProperty("outputDir", output.getAbsolutePath());

    Settings settings = new Settings(props);

    assertThat(settings.inputDir()).isEqualTo(input);
    assertThat(settings.outputDir()).isEqualTo(output);
  }

  @Test
  public void fail_if_input_dir_does_not_exist() throws Exception {
    File input = temp.newFolder("forms-sources");
    Properties props = new Properties();
    props.setProperty("inputDir", input.getAbsolutePath());
    props.setProperty("outputDir", "target/unknown");

    try {
      new Settings(props);
      fail();
    } catch (IllegalStateException e) {
      assertThat(e).hasMessage("Value of property 'outputDir' is not valid. Directory does not exist: target/unknown");
    }
  }

  @Test
  public void fail_if_mandatory_property_is_not_set() throws Exception {
    try {
      new Settings(new Properties());
      fail();
    } catch (IllegalStateException e) {
      assertThat(e).hasMessage("Property 'inputDir' is required");
    }
  }

  @Test
  public void default_forms_files() throws Exception {
    File input = temp.newFolder("forms-sources");
    File forms1 = new File(input, "foo.fmb");
    FileUtils.touch(forms1);
    File forms2 = new File(input, "bar.pll");
    FileUtils.touch(forms2);
    File other = new File(input, "other.forms");
    FileUtils.touch(other);

    File output = temp.newFolder("plsql-sources");
    Properties props = new Properties();
    props.setProperty("inputDir", input.getAbsolutePath());
    props.setProperty("outputDir", output.getAbsolutePath());

    Settings settings = new Settings(props);

    assertThat(settings.formsFiles()).containsOnly(forms1, forms2);
  }

  @Test
  public void customized_forms_files() throws Exception {
    File input = temp.newFolder("forms-sources");
    File forms1 = new File(input, "foo.fmb");
    FileUtils.touch(forms1);
    File forms2 = new File(input, "bar.forms");
    FileUtils.touch(forms2);
    File other = new File(input, "other.txt");
    FileUtils.touch(other);

    File output = temp.newFolder("plsql-sources");
    Properties props = new Properties();
    props.setProperty("inputDir", input.getAbsolutePath());
    props.setProperty("outputDir", output.getAbsolutePath());
    props.setProperty("formsExtensions", "fmb,pll,forms");

    Settings settings = new Settings(props);

    assertThat(settings.formsFiles()).containsOnly(forms1, forms2);
  }
}

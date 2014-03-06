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

import org.junit.Test;

import static org.fest.assertions.Assertions.assertThat;
import static org.fest.assertions.Fail.fail;

public class JdapiAvailabilityTest {
  @Test
  public void check() throws Exception {
    new JdapiAvailability().check();
    // does not fail because frmjdapi is available in test classpath
  }

  @Test
  public void fail_if_class_not_found() throws Exception {
    try {
      new JdapiAvailability().check("does.not.Exist");
      fail();
    } catch (IllegalStateException e) {
      assertThat(e).hasMessage("Oracle JDAPI file (usually named frmjdapi.jar) is not available in classpath");
    }
  }

  @Test
  public void success_if_class_found() throws Exception {
    new JdapiAvailability().check(PlSqlExtractor.class.getName());
    // no failure
  }
}

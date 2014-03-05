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

import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;
import org.mockito.InOrder;
import org.mockito.Mockito;

import java.io.File;
import java.util.Arrays;

import static org.mockito.Matchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class PlSqlExtractorTest {

  @Rule
  public TemporaryFolder temp = new TemporaryFolder();

  @Test
  public void run() throws Exception {
    JdapiAvailability jdapiAvailability = mock(JdapiAvailability.class);
    JdapiProxy jdapi = mock(JdapiProxy.class);
    when(jdapi.openModule(any(File.class))).thenReturn(mock(Form.class));
    Settings settings = mock(Settings.class);
    File forms1 = temp.newFile();
    File forms2 = temp.newFile();
    when(settings.formsFiles()).thenReturn(Arrays.asList(forms1, forms2));

    PlSqlExtractor extractor = new PlSqlExtractor(settings, jdapiAvailability, jdapi);
    extractor.run();

    InOrder inOrder = Mockito.inOrder(jdapiAvailability, jdapi);
    inOrder.verify(jdapiAvailability).check();
    inOrder.verify(jdapi).init();
    inOrder.verify(jdapi).openModule(forms1);
    inOrder.verify(jdapi).openModule(forms2);
    inOrder.verify(jdapi).shutdown();
  }
}

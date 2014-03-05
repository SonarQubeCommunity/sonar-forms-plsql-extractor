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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;

class PlSqlExtractor {

  private static final Logger LOG = LoggerFactory.getLogger(PlSqlExtractor.class);

  private final Settings settings;
  private final JdapiProxy jdapi;

  private PlSqlExtractor(Settings settings, JdapiProxy jdapi) {
    this.settings = settings;
    this.jdapi = jdapi;
  }

  public void run() throws IOException {
    try {
      jdapi.init();
      LOG.info("PL/SQL output directory is: " + settings.outputDir());
      for (File formFile : settings.formsFiles()) {
        extractForm(formFile, settings.outputDir());
      }
    } finally {
      jdapi.shutdown();
    }
  }

  void extractForm(File formFile, File toDir) throws IOException {
    long start = System.currentTimeMillis();
    LOG.info("Process file: " + formFile.getAbsolutePath());
    Form form = null;
    try {
      form = jdapi.openModule(formFile);
      form.extractPlsql(toDir);
    } finally {
        try {
          if (form != null) {
            form.destroy();
          }
        } catch (Exception e) {
          // ignore
          LOG.warn("Fail to clean memory", e);
        }

    }
    LOG.info("  PL/SQL code extracted in " + (System.currentTimeMillis() - start));
  }


  public static void main(String[] args) throws IOException {
    Settings settings = new Settings(System.getProperties());
    new PlSqlExtractor(settings, new JdapiProxy()).run();
  }
}

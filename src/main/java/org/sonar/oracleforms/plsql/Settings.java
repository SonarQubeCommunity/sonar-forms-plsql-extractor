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

import java.io.File;
import java.util.Collection;
import java.util.Properties;

class Settings {

  static final String[] FORMS_EXTENSIONS = {"fmb", "mmb", "olb", "pll"};

  private final File inputDir;
  private final File outputDir;

  Settings(Properties props) {
    inputDir = initDir(props, "inputDir");
    outputDir = initDir(props, "outputDir");
  }

  Collection<File> formsFiles() {
    return FileUtils.listFiles(inputDir, FORMS_EXTENSIONS, true);
  }

  File outputDir() {
    return outputDir;
  }

  private static File initDir(Properties props, String propKey) {
    String path = props.getProperty(propKey);
    if (path == null) {
      throw new IllegalArgumentException(String.format("Property '%s' is required", propKey));
    }
    File dir = new File(path);
    if (!dir.exists() || !dir.isDirectory()) {
      throw new IllegalArgumentException(String.format("Value of property '%s' is not valid. Directory does not exist: %s", propKey, path));
    }
    return dir;
  }
}

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

import oracle.forms.jdapi.*;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sonar.oracleforms.plsql.decorators.DecoratorFactory;

import javax.annotation.Nullable;
import java.io.*;

public class Form {

  private static final Logger LOG = LoggerFactory.getLogger(Form.class);

  private final JdapiModule jdapiModule;

  public static Form fromFile(File file) {
    return new Form(JdapiModule.openModule(file));
  }

  public Form(JdapiModule jdapiModule) {
    this.jdapiModule = jdapiModule;
  }

  public void extractPlsql(File toDir) throws IOException {
    LOG.debug("Browsing JDAPI nodes...");
    Node root = browse(jdapiModule, null);
    File targetDir = createTargetDir(root, toDir);
    LOG.debug("Extracting program units...");
    writeProgramUnits(root, targetDir);
    LOG.debug("Extracting GUI...");
    writeGui(root, targetDir);

  }

  private File createTargetDir(Node root, File toDir) throws IOException {
    File targetDir = new File(toDir, root.getName());
    FileUtils.forceMkdir(targetDir);
    return targetDir;
  }

  protected void writeGui(Node node, File targetDir) throws IOException {
    if (node != null && node.isModule()) {
      String plsql = DecoratorFactory.decorate(node);
      if (StringUtils.isNotBlank(plsql)) {
        File plsqlFile = createPlsqlFile(targetDir, node.getName() + "_GUI");
        Writer writer = new PrintWriter(new BufferedWriter(new FileWriter(plsqlFile)));
        try {
          writer.write(plsql);
        } finally {
          IOUtils.closeQuietly(writer);
        }
      }
    }
  }

  private void writeProgramUnits(Node node, File targetDir) throws IOException {
    if (node != null) {
      if (node.isProgramUnit() && !node.isAlias()) {
        String plsql = DecoratorFactory.decorate(node);
        if (StringUtils.isNotBlank(plsql)) {
          File plsqlFile = createPlsqlFile(targetDir, jdapiModule.getName() + "_" + node.getName());
          Writer writer = new PrintWriter(new BufferedWriter(new FileWriter(plsqlFile)));
          try {
            writer.write(plsql);

          } finally {
            IOUtils.closeQuietly(writer);
          }
        }
      }
      for (Node child : node.getChildren()) {
        writeProgramUnits(child, targetDir);
      }
    }
  }

  private Node browse(JdapiObject jdapiObject, @Nullable Node parent) throws IOException {
    Node node = new Node(parent, jdapiObject.getName());
    if (jdapiObject instanceof FormModule) {
      node.setType(Node.Type.FORM_MODULE);
      browse(((FormModule) jdapiObject).getBlocks(), node);
      browse(((FormModule) jdapiObject).getMenus(), node);
      browse(((FormModule) jdapiObject).getProgramUnits(), node);
      browse(((FormModule) jdapiObject).getTriggers(), node);

    } else if (jdapiObject instanceof MenuModule) {
      node.setType(Node.Type.MENU_MODULE);
      browse(((MenuModule) jdapiObject).getMenus(), node);
      browse(((MenuModule) jdapiObject).getProgramUnits(), node);

    } else if (jdapiObject instanceof PlsqlModule) {
      node.setType(Node.Type.PLSQL_MODULE);
      browse(((PlsqlModule) jdapiObject).getProgramUnits(), node);

    } else if (jdapiObject instanceof Block) {
      node.setType(Node.Type.BLOCK);
      browse(((Block) jdapiObject).getItems(), node);
      browse(((Block) jdapiObject).getTriggers(), node);

    } else if (jdapiObject instanceof Menu) {
      node.setType(Node.Type.MENU);
      browse(((Menu) jdapiObject).getMenuItems(), node);

    } else if (jdapiObject instanceof MenuItem) {
      node.setType(Node.Type.MENU_ITEM).setPlsql(((MenuItem) jdapiObject).getCommandText());

    } else if (jdapiObject instanceof ProgramUnit) {
      completeProgramUnit(jdapiObject, node);

    } else if (jdapiObject instanceof Trigger) {
      completeTrigger(jdapiObject, node);

    } else if (jdapiObject instanceof Item) {
      node.setType(Node.Type.ITEM);
      browse(((Item) jdapiObject).getTriggers(), node);

    } else {
      LOG.error("Not implemented type {}", jdapiObject.getClass());
    }
    if (node.isAlias()) {
      LOG.debug(node.getKey() + " is an alias of '" + node.getParentName() + "'");
    }
    return node;
  }

  private void completeProgramUnit(JdapiObject jdapiObject, Node node) {
    if (!isInherited(jdapiObject, JdapiTypes.PROGRAMUNIT_TEXT_PTID)) {
      node.setParentName(((ProgramUnit) jdapiObject).getParentName());
      node.setType(Node.Type.PROGRAM_UNIT).setPlsql(((ProgramUnit) jdapiObject).getProgramUnitText());
    } else {
      LOG.debug("Exclude inherited program unit: " + node.getKey());
    }
  }

  private void completeTrigger(JdapiObject jdapiObject, Node node) {
    if (!isInherited(jdapiObject, JdapiTypes.TRIGGER_TEXT_PTID)) {
      node.setParentName(((Trigger) jdapiObject).getParentName());
      node.setType(Node.Type.TRIGGER).setPlsql(((Trigger) jdapiObject).getTriggerText());
    } else {
      LOG.debug("Exclude inherited trigger: " + node.getKey());
    }
  }

  /**
   * Do not extract inherited PL/SQL code
   * See PLSQL-342
   */
  private boolean isInherited(JdapiObject jdapiObject, int type) {
    try {
      return jdapiObject.getPropertyState(type) == JdapiObject.PROPERTY_INHERITED_VALUE;
    } catch (Exception e) {
      // ignore, the property does not exist
      return false;
    }
  }

  private Node browse(JdapiIterator iterator, Node parent) throws IOException {
    while (iterator.hasNext()) {
      Object obj = iterator.next();
      if (obj instanceof JdapiObject) {
        browse((JdapiObject) obj, parent);
      }
    }
    return parent;
  }

  private File createPlsqlFile(File targetDir, String name) throws IOException {
    File plsqlFile = new File(targetDir, name + ".sql");
    plsqlFile.createNewFile();
    return plsqlFile;
  }

}

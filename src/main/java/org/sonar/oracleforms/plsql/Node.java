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

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.builder.ReflectionToStringBuilder;

import javax.annotation.Nullable;
import java.util.ArrayList;
import java.util.List;

public class Node {

  private static final String SEPARATOR = "/";

  public enum Type {
    FORM_MODULE, MENU_MODULE, PLSQL_MODULE, BLOCK, MENU, MENU_ITEM, PROGRAM_UNIT, TRIGGER, ITEM
  }

  private String path;
  private String name;
  private String plsql;
  private Type type;
  private final List<Node> children;
  private String parentName = null;

  public Node(@Nullable Node parent, String name) {
    this.name = name;
    this.children = new ArrayList<Node>();
    if (parent != null) {
      path = parent.getKey();
      parent.addChild(this);
    }
  }

  public Node(String name) {
    this(null, name);
  }

  public boolean isAlias() {
    return parentName != null;
  }

  public void setParentName(String parentName) {
    if (StringUtils.isNotEmpty(parentName)) {
      this.parentName = parentName;
    }
  }

  public List<Node> getChildren() {
    return children;
  }

  public List<Node> getDescendents() {
    List<Node> descendents = new ArrayList<Node>();
    fillDescendents(descendents);
    return descendents;
  }

  private void fillDescendents(List<Node> descendents) {
    for (Node child : children) {
      descendents.add(child);
      child.fillDescendents(descendents);
    }
  }

  public Node addChild(Node child) {
    if (child != null) {
      children.add(child);
    }
    return this;
  }

  public String getPath() {
    return path;
  }

  @Nullable
  public String getName() {
    return name;
  }

  public String getPlsqlName() {
    return StringUtils.replace(name, "-", "_");
  }

  public String getPlsql() {
    return plsql;
  }

  public Node setPath(String path) {
    this.path = path;
    return this;
  }

  public Node setName(String name) {
    this.name = name;
    return this;
  }

  public Node setPlsql(String plsql) {
    this.plsql = plsql;
    return this;
  }

  public boolean hasPlsql(boolean includeDescendents) {
    if (StringUtils.isNotBlank(plsql) && !isCalculatedField()) {
      return true;
    }
    if (includeDescendents) {
      for (Node descendent : getDescendents()) {
        if (descendent.hasPlsql(false)) {
          return true;
        }
      }
    }
    return false;
  }

  public boolean hasPlsql() {
    return hasPlsql(false);
  }

  public Type getType() {
    return type;
  }

  public Node setType(Type type) {
    this.type = type;
    return this;
  }

  public boolean isGuiBlock() {
    return isModule() || Type.MENU.equals(type) || Type.BLOCK.equals(type) || Type.ITEM.equals(type);
  }

  public boolean isGuiItem() {
    return Type.TRIGGER.equals(type) || Type.MENU_ITEM.equals(type);
  }

  public boolean isItem() {
    return isGuiItem() || isProgramUnit();
  }

  public boolean isGui() {
    return isGuiBlock() || isGuiItem();
  }

  public boolean isModule() {
    return Type.FORM_MODULE.equals(type) || Type.MENU_MODULE.equals(type) || Type.PLSQL_MODULE.equals(type);
  }

  public boolean isCalculatedField() {
    return "FORMULA-CALCULATION".equals(getName());
  }

  public boolean isProgramUnit() {
    return Type.PROGRAM_UNIT.equals(type);
  }

  public String getKey() {
    return new StringBuilder().append(StringUtils.defaultString(path)).append(SEPARATOR).append(StringUtils.defaultString(name)).toString();
  }

  @Override
  public String toString() {
    return new ReflectionToStringBuilder(this).toString();
  }

  public String getParentName() {
    return parentName;
  }

}

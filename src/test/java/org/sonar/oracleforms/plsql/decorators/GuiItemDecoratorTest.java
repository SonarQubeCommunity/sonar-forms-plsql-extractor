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
package org.sonar.oracleforms.plsql.decorators;

import org.junit.Test;
import org.sonar.oracleforms.plsql.Node;

import java.io.PrintWriter;
import java.io.StringWriter;

import static org.fest.assertions.Assertions.assertThat;

public class GuiItemDecoratorTest {

  GuiItemDecorator decorator = new GuiItemDecorator();

  @Test
  public void shouldNotDecorateBlankAndNoneAliasGuiItem() {
    Node node = new Node("MY_TRIGGER");
    node.setType(Node.Type.TRIGGER);
    assertThat(decorator.decorate(node, "")).isEqualTo("");
  }

  @Test
  public void shouldNotDecorateNoneBlankAndNoneAliasAndNoneGuiItem() {
    Node node = new Node("MY_TRIGGER");
    node.setType(Node.Type.PLSQL_MODULE);
    assertThat(decorator.decorate(node, "PLSQL")).isEqualTo("PLSQL");
  }

  @Test
  public void shouldNotDecorateNoneBlankButAliasGuiItem() {
    Node node = new Node("MY_TRIGGER");
    node.setType(Node.Type.TRIGGER);
    node.setParentName("parentName");
    assertThat(decorator.decorate(node, "PLSQL")).isEqualTo("PLSQL");
  }

  @Test
  public void shouldDecorateNoneBlankAndNoneAliasGuiItem() {
    Node node = new Node("MY_TRIGGER");
    node.setType(Node.Type.TRIGGER);

    StringWriter expectedResult = new StringWriter();
    PrintWriter writer = new PrintWriter(expectedResult);
    writer.println("Declare");
    writer.println("Procedure MY_TRIGGER_ Is");
    writer.println("Begin");
    writer.println("PLSQL");
    writer.println("End MY_TRIGGER_;");
    writer.println("Begin");
    writer.println("MY_TRIGGER_;");
    writer.println("End;");
    writer.flush();

    assertThat(decorator.decorate(node, "PLSQL")).isEqualTo(expectedResult.toString());
  }

}

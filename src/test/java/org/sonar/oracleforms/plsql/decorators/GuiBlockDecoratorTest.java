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

import org.junit.Before;
import org.junit.Test;
import org.sonar.oracleforms.plsql.Node;

import java.io.PrintWriter;
import java.io.StringWriter;

import static org.fest.assertions.Assertions.assertThat;

public class GuiBlockDecoratorTest {

  GuiBlockDecorator decorator = new GuiBlockDecorator();
  Node node = new Node("FORM_BLOCK");

  @Before
  public void init() {
    node.setType(Node.Type.FORM_MODULE);
  }

  @Test
  public void shouldNotDecorateNodeWitoutChildren() {
    assertThat(decorator.decorate(node, "")).isEqualTo("");
  }

  @Test
  public void shouldDecorateBlockWithChildContainingPlsql() {
    Node child = new Node("MY_TRIGGER");
    child.setPlsql("PLSQL");
    child.setType(Node.Type.TRIGGER);
    node.addChild(child);

    StringWriter expectedResult = new StringWriter();
    PrintWriter writer = new PrintWriter(expectedResult);
    writer.println("Declare");
    writer.println("Procedure FORM_BLOCK_ Is");
    writer.println("Begin");
    writer.println("-- path: /MY_TRIGGER (TRIGGER)");
    writer.println("Declare");
    writer.println("Procedure MY_TRIGGER_ Is");
    writer.println("Begin");
    writer.println("PLSQL");
    writer.println("End MY_TRIGGER_;");
    writer.println("Begin");
    writer.println("MY_TRIGGER_;");
    writer.println("End;");
    writer.println("");
    writer.println("End FORM_BLOCK_;");
    writer.println("Begin");
    writer.println("FORM_BLOCK_;");
    writer.println("End;");
    writer.flush();

    assertThat(decorator.decorate(node, "")).isEqualTo(expectedResult.toString());
  }

  @Test
  public void shouldNotDecorateBlockWithChildWithoutPlsql() {
    Node child = new Node("MY_TRIGGER");
    child.setType(Node.Type.TRIGGER);
    node.addChild(child);

    assertThat(decorator.decorate(node, "")).isEqualTo("");
  }

}

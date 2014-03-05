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

import org.apache.commons.lang.StringUtils;
import org.junit.Test;
import org.sonar.oracleforms.plsql.Node;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.fest.assertions.Assertions.assertThat;

public class DecoratorsFactoryTest {

  /**
   * Full integration test on all decorators
   */
  @Test
  public void decorateModule() {
    Node module = new Node("form1").setType(Node.Type.FORM_MODULE);
    Node trigger1 = new Node(module, "trigger1").setType(Node.Type.TRIGGER).setPlsql("content of trigger one");
    Node block = new Node(module, "block1").setType(Node.Type.BLOCK);
    Node trigger2 = new Node(block, "trigger2").setType(Node.Type.TRIGGER).setPlsql("content of trigger two");

    String plsql = DecoratorFactory.decorate(module);

    Pattern p = Pattern.compile(".*Procedure form1_.*content of trigger one.*content of trigger two.*", Pattern.DOTALL);
    Matcher m = p.matcher(plsql);
    assertThat(m.matches()).isTrue();
  }

  @Test
  public void appendPlsqlCodeOnItems() {
    Node trigger = new Node("foo").setType(Node.Type.TRIGGER).setPlsql("xxx");
    assertThat(DecoratorFactory.decorate(trigger)).startsWith("-- path: mypath");
    assertThat(DecoratorFactory.decorate(trigger)).contains("xxx");
  }

  @Test
  public void doNotAppendNull() {
    Node trigger = new Node("foo").setType(Node.Type.TRIGGER).setPlsql(null);
    assertThat(DecoratorFactory.decorate(trigger)).doesNotContain("null");
  }

  @Test
  public void calculatedFieldsAreNotExtracted() {
    Node block = new Node("block").setType(Node.Type.BLOCK);
    Node trigger = new Node(block, "FORMULA-CALCULATION").setType(Node.Type.TRIGGER).setPlsql("foo=bar;");
    assertThat(StringUtils.isBlank(DecoratorFactory.decorate(block))).isTrue();

  }


}
